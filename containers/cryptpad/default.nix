/*
CryptPad is a collaboration suite that is end-to-end encrypted and open-source.
It is designed to facilitate collaboration by synchronizing changes to documents in real time.
Since all the user data is encrypted, in the event of a breach, attackers have no way of accessing the stored content.
Furthermore, if the administrators do not modify the code, they and the service also cannot access any information about the users' content.
*/
/*
TODO
add volume(s) to container
test and see what's not working
script to install openoffice?
configure cloudflared token / add to secrets
idk see whats broken when running :D
*/
{
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
            partOf = ["podman-cryptpad-root.target"];
            wantedBy = ["podman-cryptpad-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f cryptpad";
            };
            script = ''podman network inspect cryptpad || podman network create cryptpad'';
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
        };
      };

      virtualisation.oci-containers.containers = {
        "cryptpad" = {
          image = "cryptpad/cryptpad:version-2025.3.1";
          log-driver = "journald";
          environment = {
            "CPAD_CONF" = "/cryptpad/config/config.js";
            "CPAD_MAIN_DOMAIN" = "https://cryptpad.galing.org";
            "CPAD_SANDBOX_DOMAIN" = "https://cryptpad-sb.galing.org";
          };
          volumes = [
            "customize:/cryptpad/customize:rw"

            "data/blob:/cryptpad/blob:rw"

            "data/block:/cryptpad/block:rw"

            "data/data:/cryptpad/data:rw"

            "data/files:/cryptpad/datastore:rw"

            "onlyoffice-conf:/cryptpad/onlyoffice-conf:rw"

            "onlyoffice-dist:/cryptpad/www/common/onlyoffice/dist:rw"
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
