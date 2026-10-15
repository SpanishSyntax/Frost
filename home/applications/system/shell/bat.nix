{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.system.shell.bat;
in {
  options.frost.home.apps.system.shell.bat = {
    enable = lib.mkEnableOption "Bat (cat clone with syntax highlighting and Git integration)";
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;

      config = {
        theme = "TwoDark";
        style = "numbers,changes,header";
        italic-text = "always";
      };

      extraPackages = with pkgs.bat-extras; [
        batman
        batpipe
        batdiff
        batwatch
      ];
    };

    home.shellAliases = {
      cat = "bat";
      man = "batman";
    };
  };
}
