{
  lib,
  inputs,
  stateVersion,
}: rec {
  getFiles = dir:
    lib.filter
    (file: lib.hasSuffix ".nix" (toString file))
    (lib.filesystem.listFilesRecursive dir);

  wrapBin = pkgs: {
    pkg,
    name,
    target ? null,
    displayName ? null,
    hideTarget ? true,
    env ? {},
  }: let
    targetBin =
      if target != null
      then target
      else (pkg.meta.mainProgram or pkg.pname or pkg.name);
    envExports = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: ''export ${k}="${toString v}"'') env
    );
  in
    pkgs.symlinkJoin {
      name = "${name}-wrapped";
      paths = [
        (pkgs.writeShellScriptBin name ''
          ${envExports}
          exec ${pkg}/bin/${targetBin} "$@"
        '')
        pkg
      ];
      postBuild = ''
        ${lib.optionalString (hideTarget && name != targetBin) ''
          rm -f "$out/bin/${targetBin}"
        ''}
        if [ -f "$out/share/applications/${targetBin}.desktop" ]; then
          if [ -L "$out/share" ]; then
            target_share="$(readlink "$out/share")"
            rm "$out/share"
            mkdir -p "$out/share"
            for item in "$target_share"/*; do
              ln -s "$item" "$out/share/$(basename "$item")"
            done
          fi
          if [ -L "$out/share/applications" ]; then
            target_apps="$(readlink "$out/share/applications")"
            rm "$out/share/applications"
            mkdir -p "$out/share/applications"
            for item in "$target_apps"/*; do
              ln -s "$item" "$out/share/applications/$(basename "$item")"
            done
          fi
          rm -f "$out/share/applications/${targetBin}.desktop"
          cp "${pkg}/share/applications/${targetBin}.desktop" "$out/share/applications/${name}.desktop"
          chmod u+w "$out/share/applications/${name}.desktop"
          sed -i "s|^Exec=${targetBin}|Exec=${name}|g" "$out/share/applications/${name}.desktop"
          ${lib.optionalString (displayName != null) ''
            sed -i "s|^Name=.*|Name=${displayName}|g" "$out/share/applications/${name}.desktop"
          ''}
        fi
      '';
    };

  helpers = {
    inherit getFiles mkSystem mkHome wrapBin;
  };

  mkSystem = {
    host ? null,
    system ? "x86_64-linux",
    modules ? [],
    specialArgs ? {},
  }:
    lib.nixosSystem {
      inherit system;

      modules = [
        inputs.self.nixosModules.default
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit (prev.stdenv.hostPlatform) system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ]
      ++ (
        if host != null && modules == [] && builtins.pathExists "${inputs.self}/hosts/${host}/configuration.nix"
        then ["${inputs.self}/hosts/${host}/configuration.nix"]
        else []
      )
      ++ modules;

      specialArgs = {
        inherit inputs stateVersion host getFiles helpers wrapBin;
      } // specialArgs;
    };

  mkHome = {
    username ? "frost",
    host ? null,
    system ? "x86_64-linux",
    homeDirectory ? "/home/${username}",
    modules ? [],
    specialArgs ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (prev.stdenv.hostPlatform) system;
              config.allowUnfree = true;
            };
          })
        ];
      };

      modules = [
        inputs.self.homeManagerModules.default
        {
          home.username = username;
          home.homeDirectory = homeDirectory;
          home.stateVersion = stateVersion;
          programs.home-manager.enable = true;
        }
      ]
      ++ (
        if host != null && modules == [] && builtins.pathExists "${inputs.self}/home/users/${host}.nix"
        then ["${inputs.self}/home/users/${host}.nix"]
        else []
      )
      ++ modules;

      extraSpecialArgs = {
        inherit inputs stateVersion host getFiles helpers wrapBin;
      } // specialArgs;
    };
}
