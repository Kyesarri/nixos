# ./flake.nix
{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    ags.url = "github:Aylur/ags/54fd9cf50c428bc8760ef20f05f6daffcb821896"; #v 1.5.1 Beta
    home-manager = {
      url = "github:nix-community/home-manager";
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
        specialArgs =  { inherit nix-colors inputs; };
        modules = [
          ./hosts/nix-laptop.nix
          { environment.systemPackages = [ alejandra.defaultPackage.x86_64-linux ]; }
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit nix-colors inputs; };# Pass flake input to home-manager
              users.kel.imports = [];
            };
          }
        ];
      };

      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nix-desktop.nix
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {inherit inputs;}; # Pass flake input to home-manager
          }
        ];
      };
    };
  };
}
# ./flake.nix

