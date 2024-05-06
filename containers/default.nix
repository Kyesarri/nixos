{pkgs, ...}: {
  virtualisation = {
    oci-containers.backend = "podman"; # set podman as our default backend for containers
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true; # lets us use docker commands - translate to podman
      defaultNetwork.settings.dns_enabled = true; # lets containers see each other
    };
  };
  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools # useful for monitoring igpu usage
  ];
}
