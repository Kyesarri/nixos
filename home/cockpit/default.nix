# https://fictionbecomesfact.com/nixos-cockpit-podman
{pkgs, ...}: {cockpit-podman = pkgs.callPackage ./cockpit-podman.nix {};}
