{lib, ...}: {
  disko.devices = {
    disk = {
      main = {
        device = lib.mkDefault "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
                extraArgs = [
                  "-n"
                  "Nixos-boot"
                ];
              };
            };
            ROOT = {
              label = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-L"
                    "Nixos-root"
                    "-f"
                  ];
                  subvolumes = {
                    "@" = {
                      mountOptions = [
                        "ssd"
                        "noatime"
                        "compress=zstd"
                      ];
                      mountpoint = "/";
                    };
                    "@blank" = {};
                    "@home" = {
                      mountOptions = [
                        "ssd"
                        "noatime"
                        "compress=zstd"
                        "nodev"
                        "nosuid"
                      ];
                      mountpoint = "/home";
                    };
                    "@nix" = {
                      mountOptions = [
                        "ssd"
                        "noatime"
                        "compress=zstd"
                        "nodev"
                        "nosuid"
                      ];
                      mountpoint = "/nix";
                    };
                    "@persist" = {
                      mountOptions = [
                        "ssd"
                        "noatime"
                        "compress=zstd"
                        "nodev"
                        "nosuid"
                      ];
                      mountpoint = "/persist";
                    };
                    "@swap" = {
                      mountOptions = [
                        "ssd"
                        "noatime"
                        "nodatacow"
                      ];
                      mountpoint = "/swap";
                      swap.swapfile.size = "8G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
