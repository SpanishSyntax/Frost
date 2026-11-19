{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.settings.desktop.tapes;
  pkg =
    if inputs ? tapes
    then
      pkgs.rustPlatform.buildRustPackage {
        pname = "tapes";
        version = (builtins.fromTOML (builtins.readFile "${inputs.tapes}/Cargo.toml")).package.version;
        src = inputs.tapes;
        cargoLock.lockFile = "${inputs.tapes}/Cargo.lock";
        env.RUSTC_WRAPPER = "";
        meta = {
          description = "Tapes v2 - Atomic per-target dotfile switcher";
          homepage = "https://github.com/futurekismo-oss/tapes";
          mainProgram = "tapes";
        };
      }
    else pkgs.writeShellScriptBin "tapes" "echo 'tapes input missing'; exit 1";
in {
  options.frost.home.apps.settings.desktop.tapes = {
    enable = lib.mkEnableOption "Tapes v2 atomic per-target dotfile switcher";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
      description = "The Tapes CLI package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
