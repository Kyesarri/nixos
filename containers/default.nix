{pkgs, ...}: {
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      extraPackages = [pkgs.zfs];
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools # intel igpu monitor
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in) for another #TODO jellyfin
  ];
}
# currently handles packages required / nice-to-have for containers,
# will eventually import all containers much like ~/home/default.nix is transitioning to

