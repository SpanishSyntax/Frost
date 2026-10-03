# home/environment/ignores.nix
{lib, ...}: {
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

        # MATLAB
        "*.asv"
        "*.m~"

        # OS / Sync / Editors
        ".syncthing*"
        ".DS_Store"
        "Thumbs.db"
        "*.swp"
        "*~"

        # Android / Mobile Reader temp files
        ".nomedia"
        "*.tmp"
        "*.temp"
        "*.~*"
      ];
      description = "File glob patterns to ignore across sync engines.";
    };
  };
}
