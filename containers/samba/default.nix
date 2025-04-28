{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.samba;
in {
  options.cont.samba = {
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
        targets."podman-samba-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-samba" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-samba.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-samba.service"
            ];
            partOf = ["podman-samba-root.target"];
            wantedBy = ["podman-samba-root.target"];
          };
          # volumes
          "podman-volumes-samba" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect samba || podman volume create samba
            '';
            partOf = ["podman-samba-root.target"];
            wantedBy = ["podman-samba-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "samba" = {
          image = "dockurr/samba:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            UID = "1000";
            GID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "samba:/storage"
          ];
          extraOptions = [
            "--network-alias=samba"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
