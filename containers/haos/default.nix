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
      systemd.targets."podman-haos-root" = {
        unitConfig = {Description = "root target";};
        wantedBy = ["multi-user.target"];
      };
      systemd.services = {
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
        # container
        "podman-haos-matter" = {
          serviceConfig = {Restart = lib.mkOverride 90 "always";};
          after = [
            "podman-network-internal.service"
            "podman-volume-haos-matter.service"
          ];
          requires = [
            "podman-network-internal.service"
            "podman-volume-haos-matter.service"
          ];
          partOf = ["podman-haos-root.target"];
          wantedBy = ["podman-haos-root.target"];
        };
        # volume
        "podman-volume-haos-matter" = {
          path = [pkgs.podman];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''podman volume inspect haos-matter || podman volume create haos-matter'';
          partOf = ["podman-haos-root.target"];
          wantedBy = ["podman-haos-root.target"];
        };
      };
      virtualisation.oci-containers.containers = {
        "haos" = {
          image = "ghcr.io/home-assistant/home-assistant:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "haos:/config"
            # need to mount a configuration.yaml
            # and the theme.yaml to this container
            # currently does not support reverse proxy :)
          ];
          extraOptions = [
            "--network-alias=haos"
            "--network=internal"
          ];
        };
        "haos-matter" = {
          image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/run/dbus:/run/dbus:ro"
            "/etc/localtime:/etc/localtime:ro"
            "haos-matter:/data"
          ];
          extraOptions = [
            "--network-alias=haos-matter"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
