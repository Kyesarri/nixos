/*
Enjoy a smooth and private browsing experience on multiple networks
(like https://diva.exchange or also onion and i2p sites like http://diva.i2p or
http://kopanyoc2lnsx5qwpslkik4uccej6zqna7qq2igbofhmb2qxwflwfqad.onion).
Use your favourite browser (like Firefox). Hence it should be suitable for beginners.

Please note: an entry-level setup is only a first - yet necessary - step to protect your privacy.
You need to change your behaviour to protect your online privacy (like: use NoScript, AdBlock). Also fingerprinting
(a hash of your online footprint) and obviously login data is threatening your privacy.
This project helps you to get started with private browsing.
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.i2p;
in {
  options.cont.i2p = {
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
        targets."podman-i2p-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-i2p" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volumes-i2p.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volumes-i2p.service"
            ];
            partOf = ["podman-i2p-root.target"];
            wantedBy = ["podman-i2p-root.target"];
          };
          # volumes
          "podman-volumes-i2p" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect i2pconfig || podman volume create i2pconfig && \
              podman volume inspect i2ptorrents || podman volume create i2ptorrents
            '';
            partOf = ["podman-i2p-root.target"];
            wantedBy = ["podman-i2p-root.target"];
          };
        };
      };
      /*
      List of Used Environment Variables
      The following environment variables can be used withinthe I2Pd configuration file:

      Set ENABLE_HTTPPROXY to 1 (true) or 0 (false) to enable the HTTP proxy. Defaults to 0.
      Use PORT_HTTPPROXY to define the http proxy port. Defaults to 4444.
      Set ENABLE_SOCKSPROXY to 1 (true) or 0 (false) to enable the SOCKS proxy. Defaults to 0.
      Use PORT_SOCKSPROXY to define the socks proxy port. Defaults to 4445.
      Set ENABLE_SAM to 1 (true) or 0 (false) to enable the SAM bridge. Defaults to 0.
      Use PORT_SAM to define the SAM bridge port. Defaults to 7656.
      Set ENABLE_FLOODFILL to 1 (true) or 0 (false) to create a floodfill router. Defaults to 0.
      Set BANDWIDTH to control or limit the bandwidth used by the router. Use "L" (32KBs/sec), "O" (256KBs/sec), "P" (2048KBs/sec) or "X" (unlimited). By default, the bandwidth is set to "L" for non-floodfill routers and to "X" for floodfill routers.
      Set TRANSIT_SHARE to a value between 0 (zero) and 100 to limit the bandwidth used by the router for transit. Defaults to 100.
      Set ENABLE_UPNP to 1 (true) or 0 (false) to enable UPNP. Defaults to 0 (false).
      Set ENABLE_HIDDEN to 1 (true) or 0 (false) to enable hidden mode. Defaults to 0 (false).
      Set LOGLEVEL to the desired logging level: debug, info, warn, error or none. Defaults to info.
      */
      virtualisation.oci-containers.containers = {
        "i2p" = {
          image = "divax/i2p:current";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "i2pconfig:/i2p/.i2p"
            "i2ptorrents:/i2psnark"
          ];
          extraOptions = [
            "--network-alias=i2p"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
