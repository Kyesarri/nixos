{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.i2pd;
in {
  options.cont.i2pd = {
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
        targets."podman-i2pd-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-i2pd" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volumes-i2pd.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volumes-i2pd.service"
            ];
            partOf = ["podman-i2pd-root.target"];
            wantedBy = ["podman-i2pd-root.target"];
          };
          # volumes
          "podman-volumes-i2pd" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect .i2pd || podman volume create .i2pd && \
              podman volume inspect i2pd || podman volume create i2pd
            '';
            partOf = ["podman-i2pd-root.target"];
            wantedBy = ["podman-i2pd-root.target"];
          };
        };

        virtualisation.oci-containers.containers = {
          "i2pd" = {
            image = "purplei2p/i2pd:latest";
            environment = {
              TZ = "${cfg.timeZone}";
            };
            volumes = [
              "/etc/localtime:/etc/localtime:ro"
              ".i2pd:/home/.i2pd/"
              "i2pd:/home/i2pd/"
            ];
            # cmd = ["--http.address ${secrets.ip.i2pd}" "--port=${secrets.port.i2pd}"];
            extraOptions = [
              "--network-alias=i2pd"
              "--network=internal"
            ];
          };
        };
      };
    })
  ];
}
