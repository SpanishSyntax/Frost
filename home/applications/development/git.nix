{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.frost.home.apps.development.git;
in {
  options.frost.home.apps.development.git = {
    enable = lib.mkEnableOption "GIT feature set";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "Frost User";
      description = "Git user name";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "user@example.com";
      description = "Git user email";
    };
    signByDefault = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Sign commits by default with SSH key";
    };
    allowedSigners = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Content of the ~/.ssh/allowed_signers file";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.git
      pkgs.git-lfs
      pkgs.gh
      pkgs.ghr
      pkgs.lazygit
    ];

    programs.git = {
      enable = true;
      lfs.enable = true;

      signing = {
        format = "ssh";
        signByDefault = cfg.signByDefault;
      };

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
        core = {
          editor = "nvim";
        };
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          allowedSignersFile = "~/.ssh/allowed_signers";
          defaultKeyCommand = "ssh-add -L";
        };
      };
    };

    home.file.".ssh/allowed_signers" = lib.mkIf (cfg.allowedSigners != "") {
      text = cfg.allowedSigners;
    };
  };
}
