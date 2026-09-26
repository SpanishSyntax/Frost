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
}
