{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";

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

    # ulauncher.url = "github:Ulauncher/Ulauncher";
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
    agenix,
    # ulauncher,
    ...
  } @ inputs: let
    #
    # pretty basic tings, passed through to the below nixosConfigurations, bring into scope as atributes
    # if required further in the tree { spaghetti, ... }:{ ...
    #
    # inherit foo will copy verbatim, using ${foo}; or ${foo.bar}; will call the string / value
    #
    spaghetti = {
      user = "kel"; # single user currently, import attribute as spaghetti use ${spaghetti.user}
      user1 = "test";
      plymouth = "deus_ex"; # as above, use ${spaghetti.plymouth}
      scheme = "horizon-dark";
      scheme1 = "gigavolt";
      scheme2 = "tokyonight";
      iconPkg = "pkgs.zafiro-icons";
    };
    system = "x86_64-linux"; # i dont use any other arch atm
    specialArgs = {inherit nix-colors agenix auto-cpufreq inputs prism spaghetti wallpaper-generator;};
    # ^
    # ^ FIXME -
    # ^ the specialArgs is pretty loose and a cover-all, not all systems require every input
    # ^ want to find out how i can include other inherit in each machine
    # ^ FIXME -
    #
    # the above are added to the below by calling inherit foo or by passing into specialArgs as is the case
    # with spaghetti
    #
    # imports = [./foo.nix]; # wondering if i can pass multiple atributes / fun tings
    # by importing, maybe just adding ./foo.nix? not tested either :)
    # or, import as a flake?
    #
  in {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          agenix.nixosModules.default
          auto-cpufreq.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/laptop # 4800hs / 1650 / 16gb TODO download more ram
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux]; # codium plugin
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors agenix inputs hy3 hyprland;};
            };
          }
        ];
      };
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/notebook # celeron N3050 / i"gpu" / 4gb?
          agenix.nixosModules.default
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
          agenix.nixosModules.default
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
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/serv # 15s-fq2050TU / i5-1135G7 / iris x / 8gb FIXME
          {
            environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit agenix inputs;};
            };
          }
        ];
      };
    };
  };
}
