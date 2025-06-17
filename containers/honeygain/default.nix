/*
honeygain/honeygain
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.honeygain;
in {
  options.cont.honeygain = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    email = mkOption {
      type = types.str;
      default = "";
    };
    pass = mkOption {
      type = types.str;
      default = "";
    };
    host = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root-target
      systemd = {
        targets."podman-honeygain-root" = {
          wantedBy = ["multi-user.target"];
          unitConfig = {Description = "honeygain-root-target";};
        };

        # container
        services = {
          "podman-honeygain" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-honeygain.service"];
            requires = ["podman-network-honeygain.service"];
            partOf = ["podman-honeygain-root.target"];
            wantedBy = ["podman-honeygain-root.target"];
          };

          # network
          "podman-network-honeygain" = {
            path = [pkgs.podman];
            script = ''podman network inspect honeygain || podman network create honeygain'';
            partOf = ["podman-honeygain-root.target"];
            wantedBy = ["podman-honeygain-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f honeygain";
            };
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "honeygain" = {
          log-driver = "journald";
          image = "honeygain/honeygain:latest";
          environment = {
            "TZ" = "Australia/Melbourne";
          };
          cmd = ["./honeygain -tou-accept -email '${cfg.email}' -pass '${cfg.pass}' -device '${cfg.host}'"];
          extraOptions = [
            "--network-alias=honeygain"
            "--network=honeygain"
          ];
        };
      };
    })
  ];
}
