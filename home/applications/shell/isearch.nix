{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.shell.isearch;

  # Build the script as a standalone executable binary
  isearchPackage = pkgs.writeShellApplication {
    name = "isearch";

    # Isolated runtime dependencies required by this tool
    runtimeInputs = [
      pkgs.pdfgrep
      pkgs.fzf
      pkgs.xdg-utils # Ensures xdg-open is always bundled and working
    ];

    text = ''
      if [ -z "''${1:-}" ]; then
        echo "Usage: isearch <search-term>"
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
  config = lib.mkIf cfg.enable {
    home.packages = [
      isearchPackage # Installs the binary natively to /bin/isearch
    ];
  };
}
