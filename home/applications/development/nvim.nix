{
  config,
  lib,
  linkConfig,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.development.nvim;

  mcpEnabled = config.frost.home.apps.ai.mcp_hub.enable or false;
  antigravityEnabled = config.frost.home.apps.ai.antigravity.enable or false;
in {
  imports = [inputs.mnw.homeManagerModules.mnw];

  options.frost.home.apps.development.nvim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf cfg.enable {
    # ------------------------------------------------------------
    # Core CLI tools (Neovim ecosystem runtime deps)
    # ------------------------------------------------------------
    home.packages = [
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.mnw = {
      enable = true;
      initLua = ''
        vim.g.mapleader = " "
        require("frost")
      '';

      extraLuaPackages = ps: [
      ];

      extraBinPath =
        [
          # Put your other core tools like pkgs.ripgrep or pkgs.fd here if needed
        ]
        ++ (lib.optional antigravityEnabled inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli)
        ++ (lib.optional mcpEnabled inputs.mcp-hub-server.packages.${pkgs.stdenv.hostPlatform.system}.default);

      # Keeps node loops active for background JS script tracking
      providers.nodeJs = {
        enable = mcpEnabled;
        package = pkgs.nodejs_22;
      };
      plugins = {
        dev.frost = {
          pure = "${inputs.self}/home/configs/nvim";
          impure = linkConfig "nvim";
        };
      };
    };

    # ------------------------------------------------------------
    # Optional: direnv support
    # ------------------------------------------------------------
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
