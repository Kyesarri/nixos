{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/master"; # testing flakehub
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland";

    # stylix.url = "github:danth/stylix";

    nix-colors.url = "github:misterio77/nix-colors"; # may replace with stylix

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    ags.url = "github:Aylur/ags/8f86ae9381c7b05a761e8f8d713af45489495d9d"; #v 1.5.4 Beta

    home-manager = {
      url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    hyprland,
    alejandra,
    nix-colors,
    # stylix,
    ...
  } @ inputs: let
    user = "kel"; # global username
    plymouth_theme = "deus_ex"; # device specific?
  in {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # 4800hs / 1650 / 16gb TODO download more ram
        specialArgs = {inherit nix-colors user plymouth_theme inputs;};
        modules = [
          # stylix.nixosModules.stylix
          ./hosts/laptop
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];} # codium plugins
          nixos-hardware.nixosModules.asus-zephyrus-ga401 # keep this?
          home-manager.nixosModules.home-manager
          {
            # stylix.image = ./greyscale_fins.jpg; # TODO see how much of a hassle porting my config to stylix
            # stylix.polarity = "dark"; # TODO probably need to turn all automatic theming off, or by-app only
            # as stylix attempts to add themes to existing files, and wont work on symlinks "i believe" lol
            #
            #
            # can break this down further as configuration here is almost identical between machines,
            # let in before nixosConfigurations = { system / specialArgs / all the other shit
            # really each system only requires the system-name and hosts/machine.nix to be set here
            # not exactly true as some machines will be using plymouth themes and other parts
            # however that also can be added later i believe
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;}; # pass flake input to home-manager
              users.${user}.imports = [];
            };
          }
        ];
      };
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # celeron N3050 / 4gb?
        specialArgs = {inherit nix-colors user plymouth_theme inputs;};
        modules = [
          ./hosts/notebook
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs user;};
              users.${user}.imports = [];
            };
          }
        ];
      };
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # 13900kf / 3070 / 32gb
        specialArgs = {inherit nix-colors user plymouth_theme inputs;};
        modules = [
          ./hosts/desktop
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs user;};
              users.${user}.imports = [];
            };
          }
        ];
      };
      "nix-serv" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # 15s-fq2050TU / i5-1135G7 / iris x / 8gb
        specialArgs = {inherit nix-colors user plymouth_theme inputs;};
        modules = [
          ./hosts/serv
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs user;};
              users.${user}.imports = [];
            };
          }
        ];
      };
    };
  };
}
