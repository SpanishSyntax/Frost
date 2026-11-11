{
  config,
  lib,
  ...
}: let
  cfg = config.frost.hardware.pipewire;
in {
  options.frost.hardware.pipewire = {
    enable = lib.mkEnableOption "PipeWire audio daemon";
    alsa.enable = lib.mkEnableOption "Enable ALSA PipeWire support.";
    pulse.enable = lib.mkEnableOption "Enable PulseAudio PipeWire support.";
    jack.enable = lib.mkEnableOption "Enable JACK PipeWire support.";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;

      alsa.enable = cfg.alsa.enable;
      alsa.support32Bit = true;

      pulse.enable = cfg.pulse.enable;

      jack.enable = cfg.jack.enable;
    };
  };
}
