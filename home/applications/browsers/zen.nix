{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.browsers.zen;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.frost.home.apps.browsers.zen.enable = lib.mkEnableOption "Zen browser.";

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;

      # The flake maps Firefox's enterprise policy engine straight onto Zen!
      policies = {
        SecurityDevices = {
          "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
        };
      };
    };
  };
}
