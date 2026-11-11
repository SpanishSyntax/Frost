{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.frost.home.apps.development.editors.nvim;
  env = config.frost.home.environment;
  envIgnores = env.ignores;

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
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (
        if env.mutable
        then config.programs.mnw.finalPackage.devMode
        else config.programs.mnw.finalPackage
      )
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs.mnw = {
      enable = false;
      initLua = ''
        vim.g.frost_logo_svg = "${inputs.self}/assets/wordmark.svg"
        vim.g.frost_logo_png = "${frostLogoPng}"
        vim.g.frost_ignore_directories = vim.json.decode('${builtins.toJSON envIgnores.directories}')
        vim.g.frost_ignore_files = vim.json.decode('${builtins.toJSON envIgnores.files}')

        require("frost")
      '';

      extraLuaPackages = ps: [];

      extraBinPath = [
        pkgs.ripgrep
        pkgs.fd
        pkgs.chafa
      ];

      providers = {
        nodeJs = {
          enable = true;
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
          pure =
            if env.configsPath != null
            then
              if builtins.isPath env.configsPath
              then builtins.path { path = env.configsPath + "/nvim"; name = "nvim-config"; }
              else "${env.configsPath}/nvim"
            else "${inputs.self}/configs/home/nvim";
          impure =
            if env.configsPath != null
            then
              if env.mutable && builtins.isString env.configsPath
              then "${env.configsPath}/nvim"
              else if builtins.isPath env.configsPath
              then builtins.path { path = env.configsPath + "/nvim"; name = "nvim-config"; }
              else "${env.configsPath}/nvim"
            else "${inputs.self}/configs/home/nvim";
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
