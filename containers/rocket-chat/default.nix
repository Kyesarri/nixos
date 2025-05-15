{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.rocket-chat;
in {
  options.cont.rocket-chat = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root target
      systemd = {
        targets."podman-rocket-chat-root" = {
          unitConfig = {Description = "rocket-chat root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # rocket.chat
          "podman-rocket-chat" = {
            serviceConfig = {
              Restart = lib.mkOverride 90 "always";
            };
            after = ["podman-network-rocket-chat.service"];
            requires = ["podman-network-rocket-chat.service"];
            partOf = ["podman-rocket-chat-root.target"];
            wantedBy = ["podman-rocket-chat-root.target"];
          };

          # network
          "podman-network-rocket-chat" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f rocket-chat";
            };
            script = ''podman network inspect rocket-chat || podman network create rocket-chat'';
            partOf = ["podman-rocket-chat-root.target"];
            wantedBy = ["podman-rocket-chat-root.target"];
          };

          # mongo db volume
          "podman-volume-rocket-chat_mongodb" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect rocket-chat_mongodb || podman volume create rocket-chat_mongodb
            '';
            partOf = ["podman-rocket-chat-root.target"];
            wantedBy = ["podman-rocket-chat-root.target"];
          };
          # mongo db
          "podman-rocket-chat_mongodb" = {
            serviceConfig = {
              Restart = lib.mkOverride 90 "always";
            };
            after = [
              "podman-network-rocket-chat.service"
              "podman-volume-rocket-chat_mongodb.service"
            ];
            requires = [
              "podman-network-rocket-chat.service"
              "podman-volume-rocket-chat_mongodb.service"
            ];
            partOf = ["podman-rocket-chat-root.target"];
            wantedBy = ["podman-rocket-chat-root.target"];
          };
        };
      };

      # containers
      virtualisation.oci-containers.containers = {
        # rocket.chat
        "rocket-chat" = {
          image = "registry.rocket.chat/rocketchat/rocket.chat:latest";
          environment = {
            TZ = "Australia/Melbourne";
            "DEPLOY_METHOD" = "docker";
            "DEPLOY_PLATFORM" = "";
            "MONGO_OPLOG_URL" = "mongodb://mongodb:27017/local?replicaSet=rs0";
            "MONGO_URL" = "mongodb://mongodb:27017/rocketchat?replicaSet=rs0";
            "PORT" = "3000";
            "REG_TOKEN" = "";
            "ROOT_URL" = "http://localhost:3000";
          };
          ports = [
            # "0.0.0.0:3000:3000/tcp"
          ];
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.rocketchat.entrypoints" = "https";
            "traefik.http.routers.rocketchat.rule" = "Host(``)";
            "traefik.http.routers.rocketchat.tls" = "true";
            "traefik.http.routers.rocketchat.tls.certresolver" = "le";
          };
          dependsOn = [
            "rocket-chat_mongodb"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=rocketchat"
            "--network=rocket-chat"
          ];
        };
        "rocket-chat_mongodb" = {
          image = "docker.io/bitnami/mongodb:6.0";
          environment = {
            TZ = "Australia/Melbourne";
            "ALLOW_EMPTY_PASSWORD" = "yes";
            "MONGODB_ADVERTISED_HOSTNAME" = "mongodb";
            "MONGODB_ENABLE_JOURNAL" = "true";
            "MONGODB_INITIAL_PRIMARY_HOST" = "mongodb";
            "MONGODB_INITIAL_PRIMARY_PORT_NUMBER" = "27017";
            "MONGODB_PORT_NUMBER" = "27017";
            "MONGODB_REPLICA_SET_MODE" = "primary";
            "MONGODB_REPLICA_SET_NAME" = "rs0";
          };
          volumes = [
            "rocket-chat_mongodb:/bitnami/mongodb:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=mongodb"
            "--network=rocket-chat"
          ];
        };
      };
    })
  ];
}
