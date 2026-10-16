{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.development.editors.nvim;
  envIgnores = config.frost.home.environment.ignores;

  mcpEnabled = config.frost.home.apps.ai.mcp_hub.enable or false;
  antigravityEnabled = config.frost.home.apps.ai.antigravity.enable or false;

  # Pure Nix build of PNG asset from SVG (1024px width, transparent background)
  frostLogoPng =
    pkgs.runCommand "wordmark.png" {
      nativeBuildInputs = [pkgs.resvg];
    } ''
      resvg -w 1024 "${inputs.self}/assets/wordmark.svg" $out
    '';
in {
  imports = [inputs.mnw.homeManagerModules.mnw];

  options.frost.home.apps.development.editors.nvim = {
    enable = lib.mkEnableOption "Neovim";

    configsPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.frost.home.environment.configsPath;
      example = null;
      description = ''
        Path to flox configs for out-of-store symlinking.
        Defaults to global `frost.home.environment.configsPath`.
        Set to `null` to use the pure flake store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.mnw = {
      enable = true;
      initLua = ''
        vim.g.mapleader = " "

        vim.g.frost_logo_svg = "${inputs.self}/assets/wordmark.svg"
        vim.g.frost_logo_png = "${frostLogoPng}"
        vim.g.frost_ignore_directories = vim.json.decode('${builtins.toJSON envIgnores.directories}')
        vim.g.frost_ignore_files = vim.json.decode('${builtins.toJSON envIgnores.files}')

        require("frost")
      '';

      extraLuaPackages = ps: [];

      extraBinPath =
        [
          pkgs.ripgrep
          pkgs.fd
          pkgs.chafa
        ]
        ++ (lib.optional antigravityEnabled inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli)
        ++ (lib.optional mcpEnabled inputs.mcp-hub-server.packages.${pkgs.stdenv.hostPlatform.system}.default);

      providers = {
        nodeJs = {
          enable = mcpEnabled;
          package = pkgs.nodejs_22;
        };
        python3 = {
          enable = true;
          package = pkgs.python3.withPackages (ps:
            with ps; [
              pynvim
              jupyter-client
              cairosvg
              plotly
              kaleido
              pyperclip
              nbformat
              pillow
            ]);
        };
      };
      plugins = {
        dev.frost = {
          pure = "${inputs.self}/home/configs/nvim";
          impure =
            if cfg.configsPath != null
            then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/nvim"
            else null;
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
