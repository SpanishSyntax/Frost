{...}: {
  frost.home = {
    environment = {
      fonts.enable = true;
      gtk.enable = true;
      xdg.enable = true;
    };

    apps = {
      development = {
        editors.nvim.enable = true;
        langs = {
          bash.enable = true;
          matlab.enable = true;
          nix.enable = true;
        };
        tools.git = {
          enable = true;
          userName = "Frost Starter";
          userEmail = "user@example.com";
          signByDefault = false;
        };
      };

      graphics = {
        viewers.gnome_image_viewer.enable = true;
      };

      media = {
        audio.pwvucontrol.enable = true;
      };

      network = {
        browsers.firefox.enable = true;
        remote.dnsutils.enable = true;
      };

      office = {
        readers = {
          sioyek.enable = true;
          zathura.enable = true;
        };
      };

      settings = {
        desktop.nwg_look.enable = true;
        security = {
          gnome_seahorse.enable = true;
          pass.enable = true;
        };
      };

      system = {
        core = {
          sqlite.enable = true;
          usbutils.enable = true;
          zip.enable = true;
        };
        desktop = {
          gnome_files.enable = true;
          gnome_system_monitor.enable = true;
        };
        shell = {
          bat.enable = true;
          curl.enable = true;
          eza.enable = true;
          fastfetch.enable = true;
          file.enable = true;
          fzf.enable = true;
          glow.enable = true;
          jq.enable = true;
          kitty.enable = true;
          ripgrep.enable = true;
          starship.enable = true;
          tmux.enable = true;
          tree.enable = true;
          wget.enable = true;
          zoxide.enable = true;
          zsh.enable = true;
        };
      };

      utility = {
        accessories = {
          calculator.enable = true;
          gnome_clocks.enable = true;
        };
      };
    };
  };
}
