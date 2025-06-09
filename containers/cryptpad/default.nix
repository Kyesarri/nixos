/*
CryptPad is a collaboration suite that is end-to-end encrypted and open-source.
It is designed to facilitate collaboration by synchronizing changes to documents in real time.
Since all the user data is encrypted, in the event of a breach, attackers have no way of accessing the stored content.
Furthermore, if the administrators do not modify the code, they and the service also cannot access any information about the users' content.
*/
/*
TODO
try to fix the anon files being added / randos being able to do whatever they want
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.cryptpad;
in {
  options.cont.cryptpad = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    cloudflared-token = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd = {
        targets."podman-cryptpad-root" = {
          wantedBy = ["multi-user.target"];
          unitConfig = {Description = "cryptpad root target";};
        };

        services = {
          "podman-network-cryptpad" = {
            path = [pkgs.podman];
            script = ''podman network inspect cryptpad || podman network create cryptpad'';
            partOf = ["podman-cryptpad-root.target"];
            wantedBy = ["podman-cryptpad-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f cryptpad";
            };
          };

          "podman-cryptpad" = {
            serviceConfig = {Restart = lib.mkOverride 90 "no";};
            after = ["podman-network-cryptpad.service"];
            requires = ["podman-network-cryptpad.service"];
            partOf = ["podman-cryptpad-root.target"];
            wantedBy = ["podman-cryptpad-root.target"];
          };

          "podman-cryptpad-cloudflared" = {
            serviceConfig = {
              Restart = lib.mkOverride 90 "always";
            };
            after = [
              "podman-network-cryptpad.service"
              "podman-cryptpad.service"
            ];
            requires = ["podman-network-cryptpad.service"];
            partOf = ["podman-cryptpad-root.target"];
            wantedBy = ["podman-cryptpad-root.target"];
          };
          "podman-volumes-cryptpad" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect crpd-customize || podman volume create crpd-customize & \
              podman volume inspect crpt-blob || podman volume create crpd-blob & \
              podman volume inspect crpd-block || podman volume create crpd-block & \
              podman volume inspect crpd-data || podman volume create crpd-data & \
              podman volume inspect crpd-datastore || podman volume create crpd-datastore & \
              podman volume inspect crpd-ofconf || podman volume create crpd-ofconf & \
              podman volume inspect crpd-ofdist || podman volume create crpd-ofdist
            '';
            partOf = ["podman-cryptpad-root.target"];
            wantedBy = ["podman-cryptpad-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "cryptpad" = {
          image = "cryptpad/cryptpad:version-2025.3.1";
          log-driver = "journald";
          environment = {
            "TZ" = "Australia/Melbourne";
            "CPAD_CONF" = "/cryptpad/config/config.js";
            "CPAD_MAIN_DOMAIN" = "https://cryptpad.galing.org";
            "CPAD_SANDBOX_DOMAIN" = "https://cryptpad-sb.galing.org";
            "CPAD_INSTALL_ONLYOFFICE" = "yes";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"

            # relative may be fixed in later release
            # https://github.com/containers/podman-compose/issues/1109
            "/home/kel/nixos/containers/cryptpad/config.js:/cryptpad/config/config.js:ro"
            "/home/kel/nixos/containers/cryptpad/application_config.js:/customize/application_config.js:ro"

            "crpd-customize:/cryptpad/customize:rw"
            "crpd-blob:/cryptpad/blob:rw"
            "crpd-block:/cryptpad/block:rw"
            "crpd-data:/cryptpad/data:rw"
            "crpd-datastore:/cryptpad/datastore:rw"
            "crpd-ofconf:/cryptpad/onlyoffice-conf:rw"
            "crpd-ofdist:/cryptpad/www/common/onlyoffice/dist:rw"
          ];
          ports = [
            # "3000:3000/tcp"
            # "3003:3003/tcp"
          ];
          extraOptions = [
            "--hostname=cryptpad"
            "--network-alias=cryptpad"
            "--network=cryptpad"
          ];
        };

        "cryptpad-cloudflared" = {
          log-driver = "journald";
          image = "cloudflare/cloudflared:latest";
          environment = {
            "TZ" = "Australia/Melbourne";
            "TUNNEL_TOKEN" = "${cfg.cloudflared-token}";
          };
          cmd = ["tunnel" "--no-autoupdate" "run"];
          extraOptions = [
            "--network-alias=cryptpad-cloudflared"
            "--network=cryptpad"
          ];
        };
      };
    })
  ];
}
