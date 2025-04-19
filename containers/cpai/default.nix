/**/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.cpai;
in {
  options.cont.cpai = {
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
        targets."podman-cpai-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-cpai" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-cpai.service"
              "podman-volume-cpai-modules.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-cpai-data.service"
              "podman-volume-cpai-modules.service"
            ];
            partOf = ["podman-cpai-root.target"];
            wantedBy = ["podman-cpai-root.target"];
          };
          # data volume
          "podman-volume-cpai-data" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect cpai-data || podman volume create cpai-data'';
            partOf = ["podman-cpai-root.target"];
            wantedBy = ["podman-cpai-root.target"];
          };
          # module volume
          "podman-volume-cpai-modules" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect cpai-modules || podman volume create cpai-modules'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
        };
      };
      # container
      virtualisation.oci-containers.containers = {
        "cpai" = {
          image = "codeproject/ai-server:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "cpai-data:/etc/codeproject/ai"
            "cpai-modules:/app/modules"
          ];
          extraOptions = [
            "--network-alias=cpai"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
