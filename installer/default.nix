{
  pkgs,
  inputs,
}: let
  diskoPkg = inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko;

  frostInstall = pkgs.writeShellApplication {
    name = "frost-install";
    runtimeInputs = [
      diskoPkg
      pkgs.git
      pkgs.dropbear
      pkgs.ssh-to-age
      pkgs.openssh
      pkgs.nixos-install-tools
      pkgs.coreutils
      pkgs.util-linux
    ];
    text = builtins.readFile ./install.sh;
  };

  frostRecover = pkgs.writeShellApplication {
    name = "frost-recover";
    runtimeInputs = [
      pkgs.btrfs-progs
      pkgs.coreutils
      pkgs.util-linux
      pkgs.findutils
    ];
    text = builtins.readFile ./recover.sh;
  };
in {
  inherit frostInstall frostRecover;
}
