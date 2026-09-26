{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.antigravity;
in {
  options.frost.home.apps.ai.antigravity.enable = lib.mkEnableOption "Google Antigravity";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    ];

    home.sessionVariables = {
      GEMINI_AUTH_METHOD = "antigravity";
    };
  };
}
