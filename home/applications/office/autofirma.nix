{
  pkgs,
  config,
  lib,
  host,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.office.autofirma;
in {
  imports = [
    inputs.autofirma-nix.homeManagerModules.default
  ];

  options.frost.home.apps.office.autofirma = {
    enable = lib.mkEnableOption "Autofirma feature set";
  };

  config = lib.mkIf cfg.enable {
    # Enable AutoFirma with Firefox integration
    programs.autofirma = {
      enable = true;
      firefoxIntegration.profiles = {
        default = {
          enable = true;
        };
      };
    };

    # DNIeRemote for using smartphone as DNIe reader
    programs.dnieremote = {
      enable = true;
    };
    # Note: The Android app may not be available on Google Play for modern devices.
    # See the troubleshooting guide for installation alternatives.

    # FNMT certificate configurator
    programs.configuradorfnmt = {
      enable = true;
      firefoxIntegration.profiles = {
        default = {
          enable = true;
        };
      };
    };

    # Configure Firefox
    programs.firefox = {
      policies = {
        SecurityDevices = {
          "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
        };
      };
      profiles.default = {
        id = 0;
      };
    };
  };
}
