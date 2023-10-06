# ./hosts/nix-laptop.nix
{ config, pkgs, lib,  ... }:
{

  imports =
  [
    ./shared.nix
    ../configuration.nix
    ../modules/gaming.nix
    ../modules/fonts.nix
    ../hardware/pipewire.nix
    ../hardware/nvidia.nix
    ../home/home.nix
    ./laptop-hw.nix
  ];

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-laptop";
  systemd.services.supergfxd.path = [ pkgs.pciutils ]; # gpu switching

  services.xserver =
  {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  environment =
  {
    systemPackages = with pkgs; [ pciutils ];
    shellAliases =
    {
      rebuild   = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
    };
  };
}
# ./hosts/nix-laptop.nix
