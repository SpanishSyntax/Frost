{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.searchlight;

  # Build the script as a standalone executable binary
  searchlightPackage = pkgs.writeShellApplication {
    name = "searchlight";

    # Isolated runtime dependencies required by this tool
    runtimeInputs = [
      pkgs.pdfgrep
      pkgs.fzf
      pkgs.xdg-utils # Ensures xdg-open is always bundled and working
    ];

    text = ''
      if [ -z "''${1:-}" ]; then
        echo "Usage: searchlight <search-term>"
        exit 1
      fi

      selection=$(pdfgrep -rn "$1" . 2>/dev/null | fzf --ansi --prompt="PDF Search ❯ ")

      if [ -n "$selection" ]; then
        # Safely capture the file path (everything before the first colon)
        file="''${selection%%:*}"
        echo "Opening $file..."
        xdg-open "$file"
      fi
    '';
  };
in {
  options.frost.home.apps.icebergs = {
    searchlight.enable = lib.mkEnableOption "Searchlight pdf grep";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      searchlightPackage # Installs the binary natively to /bin/searchlight
      pkgs.poppler-utils
    ];
  };
}
