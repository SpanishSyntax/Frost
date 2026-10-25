{
  description = "Frost - Modular, Declarative NixOS Starter Framework";
  inputs = {
    # Nix packages

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # Other package managers
    #################################################################

    flox = {
      url = "github:flox/flox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    # System

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # Security
    #################################################################

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix = {
      url = "github:nix-community/autofirma-nix/develop";
    };

    #################################################################
    # Virtualization
    #################################################################

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # Desktop
    #################################################################

    iio-hyprland = {
      url = "github:commonkestrel/iio-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw = {
      url = "github:Gerg-L/mnw";
    };

    #################################################################
    # Icebergs
    #################################################################

    barograph = {
      url = "github:SpanishSyntax/Barograph";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    basecamp = {
      url = "github:SpanishSyntax/Basecamp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    beacon = {
      url = "github:SpanishSyntax/Beacon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    borealis = {
      url = "github:SpanishSyntax/Borealis";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    goggles = {
      url = "github:SpanishSyntax/Goggles";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    igloo = {
      url = "github:SpanishSyntax/Igloo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # permafrost = {
    #   url = "github:SpanishSyntax/Permafrost";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    prism = {
      url = "github:SpanishSyntax/Prism";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rime = {
      url = "github:SpanishSyntax/Rime";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # shards = {
    #   url = "github:SpanishSyntax/Shards";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    sled = {
      url = "github:SpanishSyntax/Sled";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowpack = {
      url = "github:SpanishSyntax/Snowpack";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # AI
    #################################################################

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # Browsers
    #################################################################

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    #################################################################
    # Music
    #################################################################

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    inherit (inputs.nixpkgs) lib;
    stateVersion = "26.05";

    helpers = import ./lib/helpers {inherit lib inputs stateVersion;};
    inherit (helpers) mkSystem;
  in {
    lib = {
      inherit mkSystem;
      inherit (helpers) getFiles;
    };

    nixosModules = {
      default = {...}: {
        imports = [
          ./modules/modules.nix
          ./hosts/base.nix
          ./hosts/boot.nix
        ];
      };
      frost = inputs.self.nixosModules.default;
    };

    homeManagerModules = {
      default = ./home/home.nix;
      frost = inputs.self.homeManagerModules.default;
    };

    nixosConfigurations = {
      workstation = mkSystem {host = "workstation";};
      server = mkSystem {host = "server";};
    };

    packages.x86_64-linux = let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      installer = import ./installer {inherit pkgs inputs;};
    in {
      frost-install = installer.frostInstall;
      frost-recover = installer.frostRecover;
      default = installer.frostInstall;
    };

    apps.x86_64-linux = let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      installer = import ./installer {inherit pkgs inputs;};
    in {
      default = {
        type = "app";
        program = "${installer.frostInstall}/bin/frost-install";
      };
      install = {
        type = "app";
        program = "${installer.frostInstall}/bin/frost-install";
      };
      recover = {
        type = "app";
        program = "${installer.frostRecover}/bin/frost-recover";
      };
    };
  };
}
