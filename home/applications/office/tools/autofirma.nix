{
  pkgs,
  config,
  lib,
  host,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.office.tools.autofirma;
in {
  imports = [
    inputs.autofirma-nix.homeManagerModules.default
  ];

  options.frost.home.apps.office.tools.autofirma = {
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
      package = pkgs.callPackage "${inputs.autofirma-nix}/nix/dnieremote/default.nix" {
        openssl_1_1 = pkgs.openssl_1_1.overrideAttrs (oldAttrs: {
          meta = (oldAttrs.meta or {}) // {knownVulnerabilities = [];};
        });
        glibmm = pkgs.glibmm_2_4 or pkgs.glibmm;
      };
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
