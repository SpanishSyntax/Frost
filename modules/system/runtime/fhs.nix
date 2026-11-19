{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.system.runtime.fhs;
in {
  options.frost.system.runtime = {
    fhs.enable = lib.mkEnableOption "FHS feature set";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
