# ./hosts/nix-laptop.nix
{ config, pkgs, lib,  ... }:
{

  imports = [ ./shared.nix ];

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
    systemPackages = with pkgs; [  ];
    shellAliases =
    {
      rebuild   = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
    };
  };
}
# ./hosts/nix-laptop.nix
