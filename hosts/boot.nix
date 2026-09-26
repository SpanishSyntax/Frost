{
  lib,
  ...
}: {

#BOOT
  boot = {
    loader = {
      timeout = lib.mkDefault 1;
      systemd-boot.enable = lib.mkDefault true;
      efi = {
        canTouchEfiVariables = lib.mkDefault true;
        efiSysMountPoint = lib.mkDefault "/boot";
      };
    };

    kernelParams = [
      "usbcore.autosuspend=-1"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    consoleLogLevel = lib.mkDefault 3;
    initrd.verbose = lib.mkDefault false;
  };
}
