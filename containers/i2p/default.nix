/*
The Invisible Internet Project (I2P) is a fully encrypted private network layer.
It protects your activity and location. Every day people use the network to connect
with people without worry of being tracked or their data being collected.
In some cases people rely on the network when they need to be discrete or are doing sensitive work.
*/
/*
4444 	127.0.0.1 	HTTP Proxy 	TCP
4445 	127.0.0.1 	HTTPS Proxy 	TCP
6668 	127.0.0.1 	IRC Proxy 	TCP
7654 	127.0.0.1 	I2CP Protocol 	TCP
7656 	127.0.0.1 	SAM Bridge TCP 	TCP
7657 	127.0.0.1 	Router console 	TCP
7658 	127.0.0.1 	I2P Site 	TCP
7659 	127.0.0.1 	SMTP Proxy 	TCP
7660 	127.0.0.1 	POP3 Proxy 	TCP
7652 	LAN interface 	UPnP 	TCP
7653 	LAN interface 	UPnP 	UDP
12345 	0.0.0.0 	I2NP Protocol 	TCP and UDP
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

      virtualisation.oci-containers.containers = {
        "i2p" = {
          image = "geti2p/i2p:latest";
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
