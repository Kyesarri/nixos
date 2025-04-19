{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.dms;
in {
  # https://github.com/docker-mailserver/docker-mailserver/blob/master/compose.yaml
  options.cont.dms = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    fqdn = mkOption {
      type = types.str;
      default = "mail.example.com";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
    };
    image = mkOption {
      type = types.str;
      default = "ghcr.io/docker-mailserver/docker-mailserver:latest";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      environment.shellAliases = {cont-dms = "sudo podman pull ${cfg.image}";};
      systemd = {
        targets."podman-dms-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-dms" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volumes-dms.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volumes-dms.service"
            ];
            partOf = ["podman-dms-root.target"];
            wantedBy = ["podman-dms-root.target"];
          };
          # volume
          "podman-volume-dms-volumes" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect dms-mail || podman volume create dms-mail && \
              podman volume inspect dms-state || podman volume create dms-state && \
              podman volume inspect dms-logs || podman volume create dms-logs && \
              podman volume inspect dms-config || podman volume create dms-config
            '';
            partOf = ["podman-doubletake-root.target"];
            wantedBy = ["podman-doubletake-root.target"];
          };
        };
      };
      virtualisation.oci-containers.containers = {
        "dms" = {
          hostname = "${cfg.fqdn}";
          image = "${cfg.image}";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "dms-mail:/var/mail/"
            "dms-state:/var/mail-state/"
            "dms-logs:/var/log/mail/"
            "dms-config:/tmp/docker-mailserver/"
          ];
          extraOptions = [
            "--network-alias=dms"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
