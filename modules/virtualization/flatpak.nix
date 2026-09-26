{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.frost.virtualization.flatpak;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.frost.virtualization = {
    flatpak.enable = lib.mkEnableOption "Flatpak feature set";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      overrides = {
        global = {
          Context.filesystems = [ "/nix/store:ro" ];
        };
      };
    };
  };
}
