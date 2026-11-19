{
  config,
  lib,
  ...
}: {
  options = {
    frost.system.boot.console.keymap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout for the system console.";
    };
  };

  config = {
    console.keyMap = config.frost.system.boot.console.keymap;
  };
}
