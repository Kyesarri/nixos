{
  config,
  pkgs,
  ...
}: {
  # must be a better way to structure this, not a fan of
  # so much boiler-plate for each container :D
  imports = [
    ./radarr.nix
    ./sonarr.nix
    ./bazarr.nix
    ./proxarr.nix
    ./prowlarr.nix
    ./readarr.nix
  ];
  systemd.services.create-arr-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "${backend}-radarr.service"
      "${backend}-sonarr.service"
      "${backend}-bazarr.service"
      "${backend}-proxarr.service"
      "${backend}-prowlarr.service"
      "${backend}-readarr.service"
    ];
    script = ''
      ${pkgs.podman}/bin/podman network exists arr-net || \
      ${pkgs.podman}/bin/podman network create arr-net
    '';
    # this may need attention, only want proxarr to be between the podnet
    # and the local network, see how we progress
  };
}
