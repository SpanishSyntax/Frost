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
      ];
      description = "Directory names to ignore across sync engines.";
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # Nix
        "result"
        "result-*"

        # Java
        "*.class"

        # Python
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

        # OS / Editors / Sync
        ".syncthing*"
        ".DS_Store"
        "Thumbs.db"
        "*.swp"
        "*~"
      ];
      description = "File glob patterns to ignore across sync engines.";
    };
  };
}
