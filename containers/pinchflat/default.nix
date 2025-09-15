{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.pinchflat;
in {
  options.cont.pinchflat = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd = {
        targets."podman-pinchflat-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # container
          "podman-pinchflat" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-pinchflat.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-pinchflat.service"
            ];
            partOf = ["podman-pinchflat-root.target"];
            wantedBy = ["podman-pinchflat-root.target"];
          };

          # volumes
          "podman-volume-pinchflat" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect pinchflat || podman volume create pinchflat'';
            partOf = ["podman-pinchflat-root.target"];
            wantedBy = ["podman-pinchflat-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "pinchflat" = {
          image = "ghcr.io/kieraneglin/pinchflat:latest";
          log-driver = "journald";
          environment = {
            TZ = "Australia/Melbourne";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "i2pd:/config"
            #TODO "/path/to/downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=pinchflat"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
