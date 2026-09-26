{
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.pay_respects;
in {
  options.frost.home.apps.shell = {
    pay_respects.enable = lib.mkEnableOption "Pay-respects";
  };

  config = lib.mkIf cfg.enable {
    programs.pay-respects = {
      enable = true;
    };
  };
}
