/*
Client for Cloudflare Tunnel, a daemon that exposes private services through the Cloudflare edge.
*/
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.cloudflared;
in {
  options.cont.cloudflared = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root target
      systemd.targets."podman-cloudflared-root" = {
        unitConfig = {Description = "root target";};
        wantedBy = ["multi-user.target"];
      };
      # container
      systemd.services."podman-cloudflared" = {
        serviceConfig = {
          Restart = lib.mkOverride 90 "always";
        };
        after = ["podman-network-internal.service"];
        requires = ["podman-network-internal.service"];
        partOf = ["podman-cloudflared-root.target"];
        wantedBy = ["podman-cloudflared-root.target"];
      };
      # container
      virtualisation.oci-containers.containers."cloudflared" = {
        log-driver = "journald";
        image = "cloudflare/cloudflared:latest";
        environment = {
          "TZ" = "Australia/Melbourne";
          "TUNNEL_TOKEN" = "${secrets.cloudflare.token}";
        };
        cmd = ["tunnel" "--no-autoupdate" "run"];
        extraOptions = [
          # remember to add networks you want to expose via tunnel,
          # i didnt and wasted two days trying to get this to work :D
          "--network-alias=cloudflared"
          "--network=internal"
          "--network=arr"
          "--network=rocket-chat"
        ];
      };
    })
  ];
}
