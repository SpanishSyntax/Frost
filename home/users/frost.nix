{...}: {
  frost.home = {
    apps = {
      development = {
        git = {
          enable = true;
          userName = "Frost Starter";
          userEmail = "user@example.com";
          signByDefault = false;
        };
        nvim.enable = true;
      };

      shell = {
        bat.enable = true;
        curl.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        jq.enable = true;
        kitty.enable = true;
        starship.enable = true;
        tmux.enable = true;
        tree.enable = true;
        wget.enable = true;
        zsh.enable = true;
        zoxide.enable = true;
      };

      system = {
        zip.enable = true;
      };
    };
  };
}
