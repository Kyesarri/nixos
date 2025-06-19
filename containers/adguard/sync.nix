{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.adguardhome-sync;
in {
  options.cont.adguardhome-sync = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    macvlanIp = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root target
      systemd = {
        targets = {
          "podman-adguardhome-sync-root" = {
            unitConfig = {Description = "adguardhome-sync root target";};
            wantedBy = ["multi-user.target"];
          };
        };
        services = {
          # container
          "podman-adguardhome-sync" = {
            serviceConfig = {
              Restart = lib.mkOverride 90 "always";
            };
            after = ["podman-network-adguardhome-sync.service"];
            requires = ["podman-network-adguardhome-sync.service"];
            partOf = ["podman-adguardhome-sync-root.target"];
            wantedBy = ["podman-adguardhome-sync-root.target"];
          };
          # volume
          "podman-volume-adguardhome-sync" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect adguardhome-sync || podman volume create adguardhome-sync'';
            partOf = ["podman-adguardhome-sync-root.target"];
            wantedBy = ["podman-adguardhome-sync-root.target"];
          };
        };
      };
      # container
      virtualisation.oci-containers.containers = {
        "adguardhome-sync" = {
          image = "lscr.io/linuxserver/adguardhome-sync:latest";
          environment = {
            TZ = "Australia/Melbourne";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "adguardhome-sync:/config"
          ];
          ports = []; # "8080"
          log-driver = "journald";
          extraOptions = [
            "--network-alias=adguardhome-sync"
            "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          ];
        };
      };
    })
  ];
}
