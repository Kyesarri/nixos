{
  spaghetti,
  secrets,
  ...
}: let
  contName = "invidious";
  # TODO - need to make a pod with invidious and its db -
  # adding the pod to the network as a macvlan via nginx?
  # suppose this is something that i wanted to do - but never have done
in {
  virtualisation.oci-containers.containers = {
    #
    "${contName}" = {
      hostname = "${contName}";
      autoStart = true;
      image = "quay.io/invidious/invidious:latest";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.containers/${contName}/letsencrypt:/etc/letsencrypt" # TODO
      ];
      extraOptions = [
        "--network=#TODO"
        "--ip=${secrets.ip.res4}" # testing
      ];
    };
    #
    "${contName}-db" = {
      hostName = "${contName}-db";
      autoStart = true;
      image = "docker.io/library/postgres:14";
      volumes = [
        "/home/${spaghetti.user}/.containers/${contName}/postgresdata:/var/lib/postgresql/data"
        "/home/${spaghetti.user}/.containers/${contName}/sql:/config/sql"
        "/home/${spaghetti.user}/.containers/${contName}/sh/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh"
      ];
      environment = {
        POSTGRES_DB = "${contName}";
        POSTGRES_USER = "kemal";
        POSTGRES_PASSWORD = "kemal";
      };
    };
  };
}
/*
version: "3"
services:

  invidious:
    image: quay.io/invidious/invidious:latest
    # image: quay.io/invidious/invidious:latest-arm64 # ARM64/AArch64 devices
    restart: unless-stopped
    ports:
      - "127.0.0.1:3000:3000"
    environment:
      # Please read the following file for a comprehensive list of all available
      # configuration options and their associated syntax:
      # https://github.com/iv-org/invidious/blob/master/config/config.example.yml
      INVIDIOUS_CONFIG: |
        db:
          dbname: invidious
          user: kemal
          password: kemal
          host: invidious-db
          port: 5432
        check_tables: true
        # external_port:
        # domain:
        # https_only: false
        # statistics_enabled: false
        hmac_key: "CHANGE_ME!!"
    healthcheck:
      test: wget -nv --tries=1 --spider http://127.0.0.1:3000/api/v1/trending || exit 1
      interval: 30s
      timeout: 5s
      retries: 2
    logging:
      options:
        max-size: "1G"
        max-file: "4"
    depends_on:
      - invidious-db

  invidious-db:
    image: docker.io/library/postgres:14
    restart: unless-stopped
    volumes:
      - postgresdata:/var/lib/postgresql/data
      - ./config/sql:/config/sql
      - ./docker/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh
    environment:
      POSTGRES_DB: invidious
      POSTGRES_USER: kemal
      POSTGRES_PASSWORD: kemal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]

volumes:
  postgresdata:
*/

