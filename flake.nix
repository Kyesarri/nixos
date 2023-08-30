# /etc/nixos/flake.nix
{

  description = "spaghetti nixos by kye";

  inputs = {
    nixpkgs= { 
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hosts/nix-laptop.nix
          ./modules/gaming.nix
          ./modules/fonts.nix
          ./hardware/pipewire.nix
          ./hardware/nvidia.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga401 # unsure if this is loading in correctly
        ];
      };

      "nix-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
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
# /home/kel/nixos/flake.nix
