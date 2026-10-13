# home/environment/ignores.nix
{
  lib,
  config,
  ...
}: {
  options.frost.home.environment.ignores = {
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # Nix / Env
        ".direnv"
        ".devenv"

        # Rust / C / Build
        "target"
        "build"
        "cmake-build-*"
        ".cache"
        "slprj"

        # Go / Java
        "vendor"
        ".gradle"

        # JS / Web
        "node_modules"
        ".next"
        "dist"
        ".pnpm-store"
        ".turbo"

        # Python
        ".venv"
        "env"
        "__pycache__"
        ".pytest_cache"
        ".mypy_cache"
        ".ruff_cache"
        ".ipynb_checkpoints"

        # Obsidian / Editors / Tools
        ".obsidian/cache"
        ".trash"
        ".git"
        ".stversions"
        "_minted*"

        # Android / OneUI / Tablet Readers (Tab S10)
        ".trashed-*"
        ".thumbnails"
        "Android"
        "LOST.DIR"
        ".cloud"
        ".sec"
        ".samsung*"
        ".SEMarkdownTemp"
        ".xodo"
        ".koreader"
      ];
      description = "Directory names to ignore across sync engines.";
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # Nix
        "result"
        "result-*"

        # Java / Python
        "*.class"
        "*.pyc"

        # LaTeX
        "*.aux"
        "*.fls"
        "*.fdb_latexmk"
        "*.synctex.gz"
        "*.log"
        "*.bbl"
        "*.blg"
        "*.toc"
        "*.out"

        # MATLAB / Simulink
        "*.asv"
        "*.m~"
        "*.autosave"
        "*.slxc"
        "*.mex*"
        "matlab_crash_dump.*"

        # OS / Sync / Editors
        ".syncthing*"
        ".DS_Store"
        "Thumbs.db"
        "*.swp"
        "*~"
        "*.un~" # Neovim persistent undo files
        "*.orig" # Git merge conflict backups
        "*.rej" # Git rejected patches
        ".~lock.*" # LibreOffice lock files
        "~$*" # Office lock files

        # Android / Mobile Reader temp files
        ".nomedia"
        "*.tmp"
        "*.temp"
        "*.~*"
        "*.annot"
      ];
      description = "File glob patterns to ignore across sync engines.";
    };
  };

  config = {
    # Nix will generate a plain text file from your lists
    home.file.".config/frost/global_ignores".text = lib.concatStringsSep "\n" (
      config.frost.home.environment.ignores.directories
      ++ config.frost.home.environment.ignores.files
    );

    # And expose its path to the system
    home.sessionVariables.FROST_IGNORES = "${config.home.homeDirectory}/.config/frost/global_ignores";
  };
}
