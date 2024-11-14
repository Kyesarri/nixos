# https://fictionbecomesfact.com/nixos-cockpit-podman
{pkgs, ...}: {
  podman-containers = pkgs.callPackage ./cockpit-podman.nix {};
}
