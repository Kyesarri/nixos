# ./flake.nix
{

  description = "spaghetti nixos by kye";

  inputs =
  {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, nix-colors, ... }
  @inputs:
  {
    nixosConfigurations =
    {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
        [
          ./hosts/nix-laptop.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
          }
        ];
      };

      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nix-desktop.nix
          home-manager.nixosModules.home-manager
        ];  
      };
    };
  };
}
# ./flake.nix
