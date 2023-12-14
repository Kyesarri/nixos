# ./flake.nix
{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nix-colors.url = "github:misterio77/nix-colors";
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
    ...
  } @ inputs: {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit nix-colors inputs;};
        modules = [
          ./hosts/laptop
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;}; # Pass flake input to home-manager
              users.kel.imports = [];
            };
          }
        ];
      };

      "nix-notebook" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit nix-colors inputs;};
        modules = [
          ./hosts/notebook
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];} # codium plugins
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;}; # Pass flake input to home-manager
              users.kel.imports = [];
            };
          }
        ];
      };

      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit nix-colors inputs;};
        modules = [
          ./hosts/desktop/default.nix
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];} # codium plugins
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;}; # Pass flake input to home-manager
              users.kel.imports = [];
            };
          }
        ];
      };
    };
  };
}
# ./flake.nix

