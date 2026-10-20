{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.icebergs.permafrost;

  # Build the script as a standalone executable binary
  permafrostPackage = pkgs.writeShellApplication {
    name = "permafrost";

    # Isolated runtime dependencies required by this tool
    runtimeInputs = [
      pkgs.pdfgrep
      pkgs.poppler-utils
      pkgs.fzf
      pkgs.xdg-utils # Ensures xdg-open is always bundled and working
    ];

    text = ''
      if [ -z "''${1:-}" ]; then
        echo "Usage: permafrost <search-term>"
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
    permafrost.enable = lib.mkEnableOption "Permafrost pdf grep";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      permafrostPackage # Installs the binary natively to /bin/permafrost
    ];
  };
}
