{
  config,
  lib,
  ...
}: {
  options = {
    frost.system.keymap = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout for the system console.";
    };
  };

  config = {
    console.keyMap = config.frost.system.keymap;
  };
}
