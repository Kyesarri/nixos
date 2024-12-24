{
  secrets,
  lib,
  ...
}: let
  contName = "compreface";

  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers = {
    #
    # compreface-core
    "${contName}-core" = {
      hostname = "${contName}-core";
      autoStart = true;
      image = "exadel/compreface-core:latest";

      environment = {
        ML_PORT = "3000";
        IMG_LENGTH_LIMIT = "max_detect_size"; # TODO FIXME
        UWSGI_PROCESSES = "${uwsgi_processes:-2}";
        UWSGI_THREADS = "${uwsgi_threads:-1}";
      };

      extraOptions = [
        # "--network=macvlan_lan"
        # "--ip=${secrets.ip.cpai}"
      ];

      volumes = ["/etc/localtime:/etc/localtime:ro"];

      /*
      healthcheck:
      test: curl --fail http://localhost:3000/healthcheck || exit 1
      interval: 10s
      retries: 0
      start_period: 0s
      timeout: 1s
      */
    };
  };
  #
  # compreface-ui (fe)
  "${contName}-ui" = {
    hostname = "${contName}-ui";

    autoStart = true;

    image = "exadel/compreface-fe:latest";

    environment = {
      CLIENT_MAX_BODY_SIZE = "max_request_size"; # TODO FIXME
      PROXY_READ_TIMEOUT = "${read_timeout:-60000}ms";
      PROXY_CONNECT_TIMEOUT = "${connection_timeout:-10000}ms";
    }; # TODO FIXME

    extraOptions = [
      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.cpai}"
    ];

    volumes = ["/etc/localtime:/etc/localtime:ro"];
  };
  #
  # compreface-api
  "${contName}-api" = {
    hostname = "${contName}-api";

    autoStart = true;

    image = "exadel/compreface-api:latest";

    environment = {
      POSTGRES_USER = "${secrets.user.postgres}";
      POSTGRES_PASSWORD = "${secrets.password.password}";
      POSTGRES_URL = "jdbc:postgresql://${secrets.postgres_domain}:${secrets.postgres_port}/${secrets.postgres_db}";
      SPRING_PROFILES_ACTIVE = "dev";
      API_JAVA_OPTS = "${compreface_api_java_options}";
      SAVE_IMAGES_TO_DB = "${save_images_to_db}";
      MAX_FILE_SIZE = "${max_file_size}";
      MAX_REQUEST_SIZE = "${max_request_size}B";
      CONNECTION_TIMEOUT = "${connection_timeout:-10000}";
      READ_TIMEOUT = "${read_timeout:-60000}";
    }; # TODO FIXME

    extraOptions = [
      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.cpai}"
    ];

    volumes = ["/etc/localtime:/etc/localtime:ro"];
  };
  #
  # compreface-admin
  "${contName}-admin" = {
    hostname = "${contName}-admin";

    autoStart = true;

    image = "exadel/compreface-admin:latest";

    environment = {
      POSTGRES_USER = "${postgres_username}";
      POSTGRES_PASSWORD = "${postgres_password}";
      POSTGRES_URL = "jdbc:postgresql://${postgres_domain}:${postgres_port}/${postgres_db}";
      SPRING_PROFILES_ACTIVE = "dev";
      ENABLE_EMAIL_SERVER = "${enable_email_server}";
      EMAIL_HOST = "${email_host}";
      EMAIL_USERNAME = "${email_username}";
      EMAIL_FROM = "${email_from}";
      EMAIL_PASSWORD = "${email_password}";
      ADMIN_JAVA_OPTS = "${compreface_admin_java_options}";
      MAX_FILE_SIZE = "${max_file_size}";
      MAX_REQUEST_SIZE = "${max_request_size}B";
    }; # TODO FIXME

    extraOptions = [
      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.cpai}"
    ];

    volumes = ["/etc/localtime:/etc/localtime:ro"];
  };
  #
  # compreface-db (postgres-db)
  "${contName}-db" = {
    hostname = "${contName}-db";

    autoStart = true;

    image = "exadel/compreface-postgres-db:latest";

    environment = {
      POSTGRES_USER = "${postgres_username}";
      POSTGRES_PASSWORD = "${postgres_password}";
      POSTGRES_DB = "${postgres_db}";
    }; # TODO FIXME

    extraOptions = [
      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.cpai}"
    ];

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/var/lib/postgresql/data"
    ];
  };
}
