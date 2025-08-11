{
  description = "spaghetti nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0"; # codium nix
    agenix.url = "github:ryantm/agenix";
    home-manager.url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # latest git
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    # quickshell = {
    #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    ulauncher.url = "github:ulauncher/ulauncher"; # colour themes, fork
    nix-colors.url = "github:kyesarri/nix-colors"; # colour themes, fork
    prism.url = "github:IogaMaster/prism"; # wallpaper gen
    # schizofox.url = "github:schizofox/schizofox"; # firefox fork
    wallpaper-generator.url = "github:kyesarri/wallpaper-generator"; # another one
  };

  outputs = {
    agenix,
    alejandra,
    home-manager,
    hy3,
    hyprland,
    hyprpicker,
    nixpkgs,
    nix-colors,
    prism,
    self,
    wallpaper-generator,
    ...
  } @ inputs: let
    spaghetti = {
      user = "kel";
      plymouth = "deus_ex";
      scheme = "horizon-dark";
      scheme1 = "gigavolt";
      scheme2 = "papercolor-dark";
      iconPkg = "pkgs.zafiro-icons";
    };
    # import our secrets - these are required to be unencrypted when building
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    system = "x86_64-linux";
    specialArgs = {inherit nix-colors agenix hyprpicker hy3 secrets inputs prism spaghetti wallpaper-generator;};
  in {
    #
    nixosConfigurations = {
      #
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/laptop # 4800hs / 1650 / 16gb ddr4 TODO download more ram
          agenix.nixosModules.default
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false; # lets see what breaks :D
              extraSpecialArgs = {
                inherit nix-colors inputs hyprland;
                inherit (inputs.nix-colors.lib-contrib) gtkThemeFromScheme;
              };
            };
          }
        ];
      };
      #
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/notebook # celeron N3050 / intel "hd" / 4gb ddr3
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs hyprland;};
            };
          }
        ];
      };
      #
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/desktop # msi-z790i edge wifi / 13900kf / 3070 / 32gb ddr5
          agenix.nixosModules.default
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      #
      "nix-serv" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/serv # ASUS z390i / 9900k / 32gb ddr4
          agenix.nixosModules.default
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
      #
      "nix-erying" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/erying # erying Q1J2 (i7 ES 0000 13650HX or 1360P?) 14C20T / iris xe / 32gb ddr5 / 1660 super
          agenix.nixosModules.default
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-eliteone" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/eliteone # hp eliteone 85a0 / 9700 / 8gb ddr4 / uhd 630
          agenix.nixosModules.default
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
    };
  };
}
