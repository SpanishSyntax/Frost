{
  config,
  lib,
  ...
}:

let
  cfg = config.frost.programs.gaming.steam;
in
{
  options.frost.programs.gaming = {
    steam.enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}
