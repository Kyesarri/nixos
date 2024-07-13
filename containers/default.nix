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
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in)
  ];
}
