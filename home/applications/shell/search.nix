{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.shell.search;
in {
  options.frost.home.apps.shell = {
    search.enable = lib.mkEnableOption "Search";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fd
      pkgs.ripgrep
      pkgs.pdfgrep
    ];
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";

      # 1. Map your custom fd commands to the actual widget options
      fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --exclude .git";
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --exclude .git";

      # 2. Add these to ensure the default keybinds trigger correctly
      fileWidgetOptions = ["--preview 'bat --color=always --line-range :500 {}'"]; # Optional but highly recommended!
      historyWidgetOptions = ["--sort" "--exact"]; # Optional tweaks for CTRL-R
    };
    # Inject this custom Zsh function to stitch pdfgrep and fzf together!
    programs.zsh.initExtra = ''
      ipdf() {
        if [ -z "$1" ]; then
          echo "Usage: ipdf <search-term>"
          return 1
        fi

        # 1. Search text inside all PDFs recursively
        # 2. Pipe the matching lines into fzf
        # 3. Extract the filename and open it
        local selection
        selection=$(pdfgrep -rn "$1" . 2>/dev/null | fzf --ansi --prompt="PDF Search ❯ ")

        if [ -n "$selection" ]; then
          # Extracts the file path from the "filename.pdf:page: text" output
          local file
          file=$(echo "$selection" | cut -d: -f1)
          echo "Opening $file..."
          xdg-open "$file"
        fi
      }
    '';
  };
}
