{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.headscale.derp;
in {
  options.cont.headscale.derp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable self-hosted derp container, see https://tailscale.com/kb/1118/custom-derp-servers";
    };
    image = mkOption {
      type = types.str;
      default = "ghcr.io/tijjjy/tailscale-derp-docker:latest";
      example = "ghcr.io/tijjjy/tailscale-derp-docker:latest";
      description = "container image";
    };
    contName = {
      type = types.str;
      default = "derp-${config.networking.hostName}";
      example = "outlandish-tailscale-derp-container";
      description = "container name, also used for container dirs on host machine";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    autoStart = {
      type = types.bool;
      default = true;
      example = false;
      description = "auto-start container";
    };
    hostName = {
      type = types.str;
      default = "derp.my-cool-domain.xyz";
      example = "your-cool-domain.xyz/derp";
      description = "";
    };
    verifyClients = {
      type = types.bool;
      default = true;
      example = false;
      description = "";
    };
    certMode = {
      type = types.str;
      default = "manual";
      example = "letsencrypt";
      description = "use letsencrypt / manually add cert-key";
    };
    authKey = {
      type = types.str;
      default = "tskey-client-123-xyz";
      example = "tskey-client-xyz-123";
      description = "tailscale client authKey";
    };
  };
  config = mkMerge [
    (mkIf (cfg.enable == true) {
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/config /etc/oci.cont/${cfg.contName}/certs && chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = cfg.autoStart;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/run/current-system/kernel-modules:/lib/modules:ro" # icky - do we want a VM for this?
          "/etc/oci.cont/${cfg.contName}/certs:/root/derper/${cfg.contName}"
          "/etc/oci.cont/${cfg.contName}/config:/var/lib/tailscale"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
          TAILSCALE_DERP_HOSTNAME = "${cfg.hostName}";
          TAILSCALE_DERP_VERIFY_CLIENTS = "${cfg.verifyClients}";
          TAILSCALE_DERP_CERTMODE = "${cfg.certMode}";
          TAILSCALE_AUTH_KEY = "${cfg.authKey}";
        };

        cmd = [];

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
        ];
      };
    })
  ];
}
