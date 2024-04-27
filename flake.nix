{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # clan #
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    clan-core.url = "git+https://git.clan.lol/clan/clan-core";
    clan-core.inputs.nixpkgs.follows = "nixpkgs";
    clan-core.inputs.flake-parts.follows = "flake-parts";
    # clan #

    hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins. url = "github:hyprwm/hyprland-plugins";
    # hyprland-plugins.inputs.hyprland.follows = "hyprland";

    hyprpicker.url = "github:hyprwm/hyprpicker";
    hy3.url = "github:outfoxxed/hy3"; # dev branch
    hy3.inputs.hyprland.follows = "hyprland";

    nix-colors.url = "github:kyesarri/nix-colors"; # colour themes
    prism.url = "github:IogaMaster/prism"; # wallpaper gen
    wallpaper-generator.url = "github:kyesarri/wallpaper-generator"; # another one

    alejandra.url = "github:kamadorueda/alejandra/3.0.0"; # codeium nix
    ags.url = "github:Aylur/ags";

    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    hyprpicker,
    hy3,
    alejandra,
    nix-colors,
    auto-cpufreq,
    prism,
    wallpaper-generator,
    clan-core,
    sops-nix,
    ...
  } @ inputs: let
    spaghetti = {
      user = "kel";
      user1 = "test";
      plymouth = "deus_ex";
      scheme = "horizon-dark";
      scheme1 = "gigavolt";
      scheme2 = "darkviolet";
      iconPkg = "pkgs.zafiro-icons";
    };
    system = "x86_64-linux";
    specialArgs = {inherit nix-colors auto-cpufreq sops-nix inputs prism spaghetti wallpaper-generator;};
  in {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          sops-nix.nixosModules.sops
          auto-cpufreq.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/laptop # 4800hs / 1650 / 16gb TODO download more ram
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs hy3 hyprland;};
            };
          }
        ];
      };
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/notebook # celeron N3050 / i"gpu" / 4gb?
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/desktop # msi-z790i edge wifi / 13900kf / 3070 / 32gb
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-serv" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/serv # ASUS z390i / 9900k / 32gb
          # 15s-fq2050TU / i5-1135G7 / iris x / 8gb FIXME #RIP
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
      "nix-erying" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/erying # erying Q1J2 (i7 ES 0000) 14C20T/ iris xe / 32gb
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          home-manager.nixosModules.home-manager
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
