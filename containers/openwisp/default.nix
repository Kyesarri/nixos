{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.cont.openwisp;
in {
  options.cont.openwisp = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      system.activationScripts."make-openwisp-dir" =
        lib.stringAfter
        ["var"] ''mkdir -v -p /etc/oci.cont/openwisp/images /etc/oci.cont/openwisp/customization'';
      # testing without below, unsure on container image uuid / guid
      # & chown -R 1000:1000 /etc/oci.cont/openwisp

      systemd = {
        targets = {
          # root target
          #
          "podman-openwisp-root" = {
            unitConfig = {Description = "openwisp root target";};
            wantedBy = ["multi-user.target"];
          };
        }; # close targets

        services = {
          # network
          #
          "podman-network-openwisp" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f openwisp";
            };
            script = ''podman network inspect openwisp || podman network create openwisp'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };

          /*
          TODO:
          add service to clone https://github.com/openwisp/docker-openwisp.git into /etc/oci.cont/openwisp maybe?
          looks like I'm missing the images and or the containers cannot talk to the internet to get the required files
          for now manually ran git clone into dir and started the podman-build-* services
          seeing issues with containers falling over almost immediatly after starting 01.07.25

          from the autoinstall script
          git clone $GIT_PATH $INSTALL_PATH --depth 1 --branch $GIT_BRANCH &>>$LOG_FILE

          export INSTALL_PATH=/opt/openwisp/docker-openwisp
          export GIT_PATH=${GIT_PATH:-https://github.com/openwisp/docker-openwisp.git}
          */

          # builds
          #
          "podman-build-openwisp-api" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-api:latest --build-arg API_APP_PORT=8001 -f openwisp_api/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-dashboard" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-dashboard:latest --build-arg DASHBOARD_APP_PORT=8000 -f openwisp_dashboard/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-freeradius" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-freeradius:latest -f openwisp_freeradius/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-nginx" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-nginx:latest -f openwisp_nginx/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-openvpn" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-openvpn:latest -f openwisp_openvpn/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-postfix" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-postfix:latest -f openwisp_postfix/Dockerfile .
            '';
          };
          #
          "podman-build-openwisp-websocket" = {
            path = [pkgs.podman pkgs.git];
            serviceConfig = {
              Type = "oneshot";
              TimeoutSec = 300;
            };
            script = ''
              cd /etc/oci.cont/openwisp/images
              podman build -t openwisp/openwisp-websocket:latest --build-arg WEBSOCKET_APP_PORT=8002 -f openwisp_websocket/Dockerfile .
            '';
          };

          # volumes
          #
          "podman-volume-openwisp_openwisp_ssh" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_openwisp_ssh || podman volume create openwisp_openwisp_ssh'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_influxdb_data" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_influxdb_data || podman volume create openwisp_influxdb_data'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_openwisp_static" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_openwisp_static || podman volume create openwisp_openwisp_static'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_openwisp_media" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_openwisp_media || podman volume create openwisp_openwisp_media'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_openwisp_private_storage" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_openwisp_private_storage || podman volume create openwisp_openwisp_private_storage'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_openwisp_certs" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_openwisp_certs || podman volume create openwisp_openwisp_certs'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_postgres_data" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_postgres_data || podman volume create openwisp_postgres_data'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-volume-openwisp_redis_data" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect openwisp_redis_data || podman volume create openwisp_redis_data'';
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };

          # container services
          #
          "podman-openwisp-api" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-celery" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_ssh.service"
            ];
            requires = [
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_ssh.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-celery_monitoring" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
            ];
            requires = [
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-celerybeat" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-openwisp.service"];
            requires = ["podman-network-openwisp.service"];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-dashboard" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_ssh.service"
              "podman-volume-openwisp_openwisp_static.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_ssh.service"
              "podman-volume-openwisp_openwisp_static.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-freeradius" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-openwisp.service"];
            requires = ["podman-network-openwisp.service"];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-influxdb" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_influxdb_data.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-nginx" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_openwisp_certs.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_static.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_openwisp_certs.service"
              "podman-volume-openwisp_openwisp_media.service"
              "podman-volume-openwisp_openwisp_private_storage.service"
              "podman-volume-openwisp_openwisp_static.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-openvpn" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-openwisp.service"];
            requires = ["podman-network-openwisp.service"];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-postfix" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_openwisp_certs.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_openwisp_certs.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-postgres" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_postgres_data.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_postgres_data.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-redis" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_redis_data.service"
            ];
            requires = [
              "podman-network-openwisp.service"
              "podman-volume-openwisp_redis_data.service"
            ];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
          #
          "podman-openwisp-websocket" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-openwisp.service"];
            requires = ["podman-network-openwisp.service"];
            partOf = ["podman-openwisp-root.target"];
            wantedBy = ["podman-openwisp-root.target"];
          };
        }; # close services
      }; # close systemd

      virtualisation.oci-containers.containers = {
        # containers
        #
        "openwisp-api" = {
          # image = "localhost/openwisp/openwisp-api:latest";
          image = "openwisp/openwisp-api:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
            "openwisp_influxdb_data:/var/lib/influxdb:rw"
            "openwisp_openwisp_media:/opt/openwisp/media:rw"
            "openwisp_openwisp_private_storage:/opt/openwisp/private:rw"
          ];
          dependsOn = [
            "openwisp-dashboard"
            "openwisp-postgres"
            "openwisp-redis"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=api"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-celery" = {
          image = "openwisp/openwisp-dashboard:latest";
          environment = {
            "TZ" = "AEST";
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "DEBUG_MODE" = "False";

            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";

            "METRIC_COLLECTION" = "True";
            "MODULE_NAME" = "celery";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
            "openwisp_openwisp_media:/opt/openwisp/media:rw"
            "openwisp_openwisp_private_storage:/opt/openwisp/private:rw"
            "openwisp_openwisp_ssh:/home/openwisp/.ssh:rw"
          ];
          dependsOn = [
            "openwisp-dashboard"
            "openwisp-openvpn"
            "openwisp-postgres"
            "openwisp-redis"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network=container:openwisp-openvpn" # this container joins the openwisp-openvpn container namespace?
          ];
        };
        #
        "openwisp-celery_monitoring" = {
          image = "openwisp/openwisp-dashboard:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "MODULE_NAME" = "celery_monitoring";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
            "openwisp_openwisp_media:/opt/openwisp/media:rw"
            "openwisp_openwisp_private_storage:/opt/openwisp/private:rw"
          ];
          dependsOn = [
            "openwisp-dashboard"
            "openwisp-openvpn"
            "openwisp-postgres"
            "openwisp-redis"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network=container:openwisp-openvpn" # this container joins the openwisp-openvpn container namespace?
          ];
        };
        #
        "openwisp-celerybeat" = {
          image = "openwisp/openwisp-dashboard:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "MODULE_NAME" = "celerybeat";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
          ];
          dependsOn = [
            "openwisp-dashboard"
            "openwisp-postgres"
            "openwisp-redis"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=celerybeat"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-dashboard" = {
          # image = "localhost/openwisp/openwisp-dashboard:latest";
          image = "openwisp/openwisp-dashboard:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
            "openwisp_influxdb_data:/var/lib/influxdb:rw"
            "openwisp_openwisp_media:/opt/openwisp/media:rw"
            "openwisp_openwisp_private_storage:/opt/openwisp/private:rw"
            "openwisp_openwisp_ssh:/home/openwisp/.ssh:rw"
            "openwisp_openwisp_static:/opt/openwisp/static:rw"
          ];
          dependsOn = [
            "openwisp-influxdb"
            "openwisp-postfix"
            "openwisp-postgres"
            "openwisp-redis"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=dashboard"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-freeradius" = {
          # image = "localhost/openwisp/openwisp-freeradius:latest";
          image = "openwisp/openwisp-freeradius:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          ports = [
            "1812:1812/udp"
            "1813:1813/udp"
          ];
          dependsOn = [
            "openwisp-api"
            "openwisp-dashboard"
            "openwisp-postgres"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=freeradius"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-influxdb" = {
          image = "influxdb:1.8-alpine";
          environment = {
            "INFLUXDB_DB" = "openwisp";
            "INFLUXDB_USER" = "admin";
            "INFLUXDB_USER_PASSWORD" = "admin";
          };
          volumes = [
            "openwisp_influxdb_data:/var/lib/influxdb:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=influxdb"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-nginx" = {
          # image = "localhost/openwisp/openwisp-nginx:latest";
          image = "openwisp/openwisp-nginx:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/theme:/opt/openwisp/public/custom:ro"
            "openwisp_openwisp_certs:/etc/letsencrypt:rw"
            "openwisp_openwisp_media:/opt/openwisp/public/media:ro"
            "openwisp_openwisp_private_storage:/opt/openwisp/public/private:ro"
            "openwisp_openwisp_static:/opt/openwisp/public/static:ro"
          ];
          ports = [
            "80:80/tcp"
            "443:443/tcp"
          ];
          dependsOn = [
            "openwisp-api"
            "openwisp-dashboard"
            "openwisp-websocket"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=nginx"
            "--network=openwisp:alias=dashboard.internal,alias=api.internal"
          ];
        };
        #
        "openwisp-openvpn" = {
          # image = "localhost/openwisp/openwisp-openvpn:latest";
          image = "openwisp/openwisp-openvpn:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          ports = [
            "1194:1194/udp"
          ];
          dependsOn = [
            "openwisp-postgres"
          ];
          log-driver = "journald";
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--device=/dev/net/tun:/dev/net/tun:rwm"
            "--health-cmd=[\"pgrep\", \"-f\", \"openvpn\"]"
            "--health-interval=30s"
            "--health-retries=30"
            "--health-start-period=1m30s"
            "--health-timeout=10s"
            "--network-alias=openvpn"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-postfix" = {
          # image = "localhost/openwisp/openwisp-postfix:latest";
          image = "openwisp/openwisp-postfix:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "openwisp_openwisp_certs:/etc/ssl/mail:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=postfix"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-postgres" = {
          image = "postgis/postgis:15-3.4-alpine";
          environment = {
            "POSTGRES_DB" = "openwisp";
            "POSTGRES_PASSWORD" = "admin";
            "POSTGRES_USER" = "admin";
            "TZ" = "AEST";
          };
          volumes = [
            "openwisp_postgres_data:/var/lib/postgresql/data:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=postgres"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-redis" = {
          image = "redis:alpine";
          volumes = [
            "openwisp_redis_data:/data:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=redis"
            "--network=openwisp"
          ];
        };
        #
        "openwisp-websocket" = {
          # image = "localhost/openwisp/openwisp-websocket:latest";
          image = "openwisp/openwisp-websocket:latest";
          environment = {
            "API_DOMAIN" = "api.openwisp.home";
            "CERT_ADMIN_EMAIL" = "example@example.org";
            "COLLECTSTATIC_WHEN_DEPS_CHANGE" = "true";
            "DASHBOARD_DOMAIN" = "openwisp.home";
            "DB_NAME" = "openwisp";
            "DB_PASS" = "admin";
            "DB_USER" = "admin";
            "DEBUG_MODE" = "False";
            "DJANGO_LANGUAGE_CODE" = "en-gb";
            "DJANGO_LOG_LEVEL" = "INFO";
            "DJANGO_SECRET_KEY" = "default_secret_key";
            "EMAIL_DJANGO_DEFAULT" = "example@example.org";
            "INFLUXDB_NAME" = "openwisp";
            "INFLUXDB_PASS" = "admin";
            "INFLUXDB_USER" = "admin";
            "METRIC_COLLECTION" = "True";
            "OPENWISP_CELERY_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_FIRMWARE_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_CHECKS_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_MONITORING_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_CELERY_NETWORK_COMMAND_FLAGS" = "--concurrency=1";
            "OPENWISP_GEOCODING_CHECK" = "True";
            "SSH_PRIVATE_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519";
            "SSH_PUBLIC_KEY_PATH" = "/home/openwisp/.ssh/id_ed25519.pub";
            "SSL_CERT_MODE" = "no";
            "TZ" = "AEST";
            "USE_OPENWISP_CELERY_FIRMWARE" = "True";
            "USE_OPENWISP_CELERY_MONITORING" = "True";
            "USE_OPENWISP_CELERY_NETWORK" = "True";
            "USE_OPENWISP_CELERY_TASK_ROUTES_DEFAULTS" = "True";
            "USE_OPENWISP_FIRMWARE" = "True";
            "USE_OPENWISP_MONITORING" = "True";
            "USE_OPENWISP_RADIUS" = "True";
            "USE_OPENWISP_TOPOLOGY" = "True";
            "UWSGI_LISTEN" = "100";
            "UWSGI_PROCESSES" = "2";
            "UWSGI_THREADS" = "2";
            "VPN_CLIENT_NAME" = "default-management-vpn";
            "VPN_DOMAIN" = "vpn.openwisp.home";
            "VPN_NAME" = "default";
            "X509_CITY" = "New Delhi";
            "X509_COMMON_NAME" = "OpenWISP";
            "X509_COUNTRY_CODE" = "IN";
            "X509_EMAIL" = "certificate@example.com";
            "X509_NAME_CA" = "default";
            "X509_NAME_CERT" = "default";
            "X509_ORGANIZATION_NAME" = "OpenWISP";
            "X509_ORGANIZATION_UNIT_NAME" = "OpenWISP";
            "X509_STATE" = "Delhi";
          };
          volumes = [
            "/etc/oci.cont/openwisp/customization/configuration/django:/opt/openwisp/openwisp/configuration:ro"
          ];
          dependsOn = [
            "openwisp-dashboard"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=websocket"
            "--network=openwisp"
          ];
        };
      }; # close containers
    })
  ];
}
