{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.programs.flatpak;
in {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.frost.programs = {
    flatpak.enable = lib.mkEnableOption "Flatpak feature set";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      overrides = {
        global = {
          Context.filesystems = ["/nix/store:ro"];
        };
      };
    };

    frost.system.storage.impermanence.directories = [
      "/var/lib/flatpak"
    ];
  };
}
