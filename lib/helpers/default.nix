{
  lib,
  inputs,
  stateVersion,
}: rec {
  getFiles = dir:
    lib.filter
    (file: lib.hasSuffix ".nix" (toString file))
    (lib.filesystem.listFilesRecursive dir);

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
        inherit inputs stateVersion host getFiles;
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
        inherit inputs stateVersion host getFiles;
      } // specialArgs;
    };
}
