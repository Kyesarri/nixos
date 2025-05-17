/*
A cross-platform, high-performance & asynchronous web server for static files serving
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.static-web;
in {
  options.cont.static-web = {
    enable = mkEnableOption "static-web";
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # create container directories in /etc then change owner / group
      system.activationScripts."makeStaticWebdir" = lib.stringAfter ["var"] ''
        mkdir -v -p /etc/oci.cont/static-web/etc /etc/oci.cont/static-web/public \
        && chown -R 1000:1000 /etc/oci.cont/static-web'';

      # write a file from tree to specific directory
      environment.etc."oci.cont/static-web/etc/config.toml" = {
        mode = "644";
        uid = 1000;
        gid = 1000;
        source = ./config.toml;
      };

      # root target
      systemd = {
        targets."podman-static-web-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # container
          "podman-static-web" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-internal.service"];
            requires = ["podman-network-internal.service"];
            partOf = ["podman-static-web-root.target"];
            wantedBy = ["podman-static-web-root.target"];
          };
        };
      };

      # container
      virtualisation.oci-containers.containers = {
        "static-web" = {
          image = "joseluisq/static-web-server:latest";
          log-driver = "journald";
          environment = {
            TZ = "Australia/Melbourne";
            PUID = "1000";
            PGID = "1000";
            SERVER_ROOT = "/var/public";
            SERVER_CONFIG_FILE = "/etc/config.toml";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/etc/oci.cont/static-web/public:/var/public"
            "/etc/oci.cont/static-web/etc:/etc"
          ];
          extraOptions = [
            "--network-alias=static-web"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
