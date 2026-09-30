{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.frost.home.apps.music.spotify;
in {
  options.frost.home.apps.music.spotify.enable = lib.mkEnableOption "Spotify";

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
        bookmark
        # fullAppDisplay
        # shuffle
        # trashbin
        keyboardShortcut
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];

      theme = spicePkgs.themes.dribbblish;
      colorScheme = "gruvbox-material-dark";
    };
  };
}
