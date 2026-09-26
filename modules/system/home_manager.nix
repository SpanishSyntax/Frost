{
  config,
  lib,
  inputs,
  stateVersion,
  host,
  getFiles,
  ...
}: let
  cfg = config.frost.system.home_manager;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.frost.system.home_manager = {
    enable = lib.mkEnableOption "Home Manager setup";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs stateVersion host getFiles;};
      sharedModules = [
        ../../home/home.nix
      ];
    };
  };
}
