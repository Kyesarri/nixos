{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.cont.backend-network;
in {
  options.cont.backend-network = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable podman-backend network";
    };
    subnet = mkOption {
      type = types.str;
      default = "10.10.0.0";
      example = "10.10.0.0";
      description = "network subnet range";
    };
    mask = mkOption {
      type = types.str;
      default = "24";
      example = "25";
      description = "network subnet mask, / not required";
    };
    range = mkOption {
      type = types.str;
      default = "10.10.0.255";
      example = "10.10.0.255";
      description = "network ip range";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd.services.podman-backend-network = {
        path = [pkgs.podman];
        description = "create backend podman network";
        wantedBy = [
          "podman-tailscale-${config.networking.hostName}-subnet.service"
          "podman-adguard-${config.networking.hostName}.service"
        ];
        script = ''podman network exists podman-backend || podman network create --internal --dns-search=internal --subnet=${cfg.subnet}/${cfg.mask} --ip-range=${cfg.range}/${cfg.mask} podman-backend'';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "${pkgs.podman}/bin/podman network rm -f podman-backend";
        };
      };
    })
  ];
}
