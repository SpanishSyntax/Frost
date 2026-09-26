{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.leisure.steam;
in
{
  options.frost.leisure = {
    steam.enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}
