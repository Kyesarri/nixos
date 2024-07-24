{
  description = "spaghetti nixos";

  inputs = {
    # nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=cba1ade848feac44b2eda677503900639581c3f4"; # v0.40.0
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; # latest git

    hyprpicker.url = "github:hyprwm/hyprpicker";

    # hy3.url = "github:outfoxxed/hy3";
    # hy3.inputs.hyprland.follows = "hyprland";

    # hycov.url = "github:DreamMaoMao/hycov";
    # hycov.inputs.hyprland.follows = "hyprland";

    # Hyprspace.url = "github:KZDKM/Hyprspace";
    # Hyprspace.inputs.hyprland.follows = "hyprland";

    nix-colors.url = "github:kyesarri/nix-colors"; # colour themes, my fork
    prism.url = "github:IogaMaster/prism"; # wallpaper gen
    wallpaper-generator.url = "github:kyesarri/wallpaper-generator"; # another one

    alejandra.url = "github:kamadorueda/alejandra/3.0.0"; # codeium nix

    ags.url = "github:Aylur/ags"; # shell

    # auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    # auto-cpufreq.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    hyprpicker,
    # Hyprspace,
    # hy3,
    # hycov,
    alejandra,
    nix-colors,
    # auto-cpufreq,
    prism,
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
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    system = "x86_64-linux";
    specialArgs = {inherit nix-colors secrets inputs prism spaghetti wallpaper-generator;}; # auto-cpufreq
  in {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          # auto-cpufreq.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/laptop # 4800hs / 1650 / 16gb ddr4 TODO download more ram
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs hyprland;};
            };
          }
        ];
      };
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/notebook # celeron N3050 / intel "hd" / 4gb ddr3
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs hyprland;};
            };
          }
        ];
      };
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/desktop # msi-z790i edge wifi / 13900kf / 3070 / 32gb ddr5
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
      "nix-serv" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/serv # ASUS z390i / 9900k / 32gb ddr5
          # 15s-fq2050TU / i5-1135G7 / iris x / 8gb ddr4 FIXME #RIP
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
          home-manager.nixosModules.home-manager
          ./hosts/erying # erying Q1J2 (i7 ES 0000) 14C20T / iris xe / 32gb ddr5
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
