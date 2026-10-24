{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.ai.learnharness;
in {
  options.frost.home.apps.ai.learnharness = {
    enable = lib.mkEnableOption "LearnHarness AI learning agent harness";

    package = lib.mkOption {
      type = lib.types.package;
      default =
        if inputs ? learnharness
        then inputs.learnharness.packages.${pkgs.stdenv.hostPlatform.system}.default
        else pkgs.writeShellScriptBin "learnharness" "echo 'learnharness flake input not configured'; exit 1";
      description = "The LearnHarness launcher package.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
