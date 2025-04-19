{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.haos;
in {
  options.cont.haos = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd = {
        targets."podman-haos-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-haos" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-haos.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-haos.service"
            ];
            partOf = ["podman-haos-root.target"];
            wantedBy = ["podman-haos-root.target"];
          };
          # volume
          "podman-volume-haos" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect haos || podman volume create haos'';
            partOf = ["podman-haos-root.target"];
            wantedBy = ["podman-haos-root.target"];
          };
        };
      };
      virtualisation.oci-containers.containers = {
        "haos" = {
          image = "ghcr.io/home-assistant/home-assistant:latest";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "haos:/config"
          ];
          extraOptions = [
            "--network-alias=haos"
            "--privileged"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
