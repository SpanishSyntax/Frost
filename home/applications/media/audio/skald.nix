{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.media.audio.skald;
in {
  imports = lib.optional (inputs ? skald) inputs.skald.homeManagerModules.default;

  options.frost.home.apps.media.audio.skald = {
    enable = lib.mkEnableOption "Skald - Arctic oral companion & multi-chapter M4B audiobook compiler";
  };

  config = lib.mkIf cfg.enable {
    programs.skald.enable = true;
  };
}
