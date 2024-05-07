{pkgs, ...}: {
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools # intel igpu monitor
  ];
}
