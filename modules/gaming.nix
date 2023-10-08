# ./modules/gaming.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
      dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
    };
  };
}
# ./modules/gaming.nix

