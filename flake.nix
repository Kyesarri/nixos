# ./flake.nix
{

  description = "spaghetti nixos by kye";

  inputs =
  {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };


  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # allows access to flake inputs in nixos modules
        modules = # need to refactor the below
        [
          ./configuration.nix
          ./hosts/nix-laptop.nix
          ./modules/gaming.nix
          ./modules/fonts.nix
#          ./modules/colour.nix
          ./hardware/pipewire.nix
          ./hardware/nvidia.nix
          ./home.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga401 # unsure if this is loading in correctly
          home-manager.nixosModules.home-manager
          ];
      };

      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ # same as above, needs to be refactored
          ./hardware/openrgb.nix
          ./configuration.nix
          ./hosts/nix-desktop.nix
          ./modules/gaming.nix
          ./modules/fonts.nix
          ./hardware/pipewire.nix
          ./hardware/nvidia.nix
        ];  
      };
    };
  };
}
# ./flake.nix
