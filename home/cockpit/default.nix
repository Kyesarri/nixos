# https://fictionbecomesfact.com/nixos-cockpit-podman
{pkgs, ...}: let
  cockpit-apps = pkgs.callPackage ./cockpit-podman.nix;
in {
  environment.systemPackages = with pkgs; [
    cockpit
    cockpit-apps.podman-containers
  ];
}
