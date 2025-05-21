/*
mailcow: dockerized is an open source groupware/email suite based on docker.
mailcow relies on many well known and long used components,
which in combination result in an all around carefree email server.

not finished yet, plenty more TODO :D
add docker podman.socket support
fix volumes - add only podman-volumes
remove ports
cleanup ~1200 lines
test
turn into module
fix any unforseen issues
sigh
*/
{
  pkgs,
  lib,
  ...
}: {
  virtualisation.oci-containers.containers."mailcow-acme-mailcow" = {
    image = "ghcr.io/mailcow/acme:1.92";
    environment = {
      "ACME_CONTACT" = "";
      "ADDITIONAL_SAN" = "";
      "AUTODISCOVER_SAN" = "y";
      "COMPOSE_PROJECT_NAME" = "mailcow";
      "DBNAME" = "";
      "DBPASS" = "";
      "DBUSER" = "";
      "DIRECTORY_URL" = "";
      "ENABLE_SSL_SNI" = "n";
      "LE_STAGING" = "n";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "ONLY_MAILCOW_HOSTNAME" = "n";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SKIP_HTTP_VERIFICATION" = "n";
      "SKIP_IP_CHECK" = "n";
      "SKIP_LETS_ENCRYPT" = "n";
      "SNAT6_TO_SOURCE" = "n";
      "SNAT_TO_SOURCE" = "n";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/assets/ssl:/var/lib/acme:rw,z"
      "/etc/oci.cont/mailcow/data/assets/ssl-example:/var/lib/ssl-example:ro,Z"
      "/etc/oci.cont/data/web/.well-known/acme-challenge:/var/www/acme:rw,z"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
    ];
    dependsOn = [
      "mailcow-nginx-mailcow"
      "mailcow-unbound-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=acme-mailcow"
      "--network=mailcow_mailcow-network:alias=acme"
    ];
  };
  systemd.services."podman-mailcow-acme-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-clamd-mailcow" = {
    image = "ghcr.io/mailcow/clamd:1.70";
    environment = {
      "SKIP_CLAMD" = "n";
      "TZ" = "";
    };
    volumes = [
      # "/etc/oci.cont/mailcow/data/conf/clamav:/etc/clamav:rw,Z"
      "/etc/oci.cont/mailcow-dockerized/data/conf/clamav:/etc/clamav:rw,Z"
      "mailcow_clamd-db-vol-1:/var/lib/clamav:rw"
    ];
    dependsOn = [
      "mailcow-unbound-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=clamd-mailcow"
      "--network=mailcow_mailcow-network:alias=clamd"
    ];
  };
  systemd.services."podman-mailcow-clamd-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_clamd-db-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_clamd-db-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-dockerapi-mailcow" = {
    image = "ghcr.io/mailcow/dockerapi:2.11";
    environment = {
      "DBROOT" = "";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "TZ" = "";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=dockerapi-mailcow"
      "--network=mailcow_mailcow-network:alias=dockerapi"
      "--security-opt=label=disable"
    ];
  };
  systemd.services."podman-mailcow-dockerapi-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-dovecot-mailcow" = {
    image = "ghcr.io/mailcow/dovecot:2.33";
    environment = {
      "ACL_ANYONE" = "disallow";
      "ALLOW_ADMIN_EMAIL_LOGIN" = "n";
      "COMPOSE_PROJECT_NAME" = "mailcow";
      "DBNAME" = "";
      "DBPASS" = "";
      "DBUSER" = "";
      "DOVEADM_REPLICA_PORT" = "";
      "DOVECOT_MASTER_PASS" = "";
      "DOVECOT_MASTER_USER" = "";
      "FTS_HEAP" = "512";
      "FTS_PROCS" = "3";
      "IPV4_NETWORK" = "172.22.1";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "MAILCOW_PASS_SCHEME" = "BLF-CRYPT";
      "MAILCOW_REPLICA_IP" = "";
      "MAILDIR_GC_TIME" = "7200";
      "MAILDIR_SUB" = "";
      "MASTER" = "y";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SKIP_FTS" = "y";
      "TZ" = "";
    };
    volumes = [
      # "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/assets/templates:/templates:rw,z"
      "/etc/oci.cont/mailcow/data/conf/dovecot:/etc/dovecot:rw,z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/sogo-sso:/etc/phpfpm:rw,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/custom:/etc/rspamd/custom:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo:/etc/sogo:rw,z"
      "/etc/oci.cont/mailcow/data/hooks/dovecot:/hooks:rw,Z"
      "mailcow_crypt-vol-1:/mail_crypt:rw"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_rspamd-vol-1:/var/lib/rspamd:rw"
      "mailcow_vmail-index-vol-1:/var/vmail_index:rw"
      "mailcow_vmail-vol-1:/var/vmail:rw"
    ];
    ports = [
      "127.0.0.1:19991:12345/tcp"
      "143:143/tcp"
      "993:993/tcp"
      "110:110/tcp"
      "995:995/tcp"
      "4190:4190/tcp"
    ];
    labels = {
      "ofelia.enabled" = "true";
      "ofelia.job-exec.dovecot_clean_q_aged.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu vmail /usr/local/bin/clean_q_aged.sh || exit 0\"";
      "ofelia.job-exec.dovecot_clean_q_aged.schedule" = "@every 24h";
      "ofelia.job-exec.dovecot_fts.command" = "/bin/bash -c \"/usr/local/bin/gosu vmail /usr/local/bin/optimize-fts.sh\"";
      "ofelia.job-exec.dovecot_fts.schedule" = "@every 24h";
      "ofelia.job-exec.dovecot_imapsync_runner.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu nobody /usr/local/bin/imapsync_runner.pl || exit 0\"";
      "ofelia.job-exec.dovecot_imapsync_runner.no-overlap" = "true";
      "ofelia.job-exec.dovecot_imapsync_runner.schedule" = "@every 1m";
      "ofelia.job-exec.dovecot_maildir_gc.command" = "/bin/bash -c \"source /source_env.sh ; /usr/local/bin/gosu vmail /usr/local/bin/maildir_gc.sh\"";
      "ofelia.job-exec.dovecot_maildir_gc.schedule" = "@every 30m";
      "ofelia.job-exec.dovecot_quarantine.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu vmail /usr/local/bin/quarantine_notify.py || exit 0\"";
      "ofelia.job-exec.dovecot_quarantine.schedule" = "@every 20m";
      "ofelia.job-exec.dovecot_repl_health.command" = "/bin/bash -c \"/usr/local/bin/gosu vmail /usr/local/bin/repl_health.sh\"";
      "ofelia.job-exec.dovecot_repl_health.schedule" = "@every 5m";
      "ofelia.job-exec.dovecot_sarules.command" = "/bin/bash -c \"/usr/local/bin/sa-rules.sh\"";
      "ofelia.job-exec.dovecot_sarules.schedule" = "@every 24h";
      "ofelia.job-exec.dovecot_trim_logs.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu vmail /usr/local/bin/trim_logs.sh || exit 0\"";
      "ofelia.job-exec.dovecot_trim_logs.schedule" = "@every 1m";
    };
    dependsOn = [
      "mailcow-mysql-mailcow"
      "mailcow-netfilter-mailcow"
      "mailcow-redis-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_BIND_SERVICE"
      "--dns=172.22.1.254"
      "--ip=172.22.1.250"
      "--network-alias=dovecot-mailcow"
      "--network=mailcow_mailcow-network:alias=dovecot"
    ];
  };
  systemd.services."podman-mailcow-dovecot-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_crypt-vol-1.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
      "podman-volume-mailcow_vmail-index-vol-1.service"
      "podman-volume-mailcow_vmail-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_crypt-vol-1.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
      "podman-volume-mailcow_vmail-index-vol-1.service"
      "podman-volume-mailcow_vmail-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-ipv6nat-mailcow" = {
    image = "robbertkl/ipv6nat";
    environment = {
      "TZ" = "";
    };
    volumes = [
      "/lib/modules:/lib/modules:ro"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    dependsOn = [
      "mailcow-acme-mailcow"
      "mailcow-clamd-mailcow"
      "mailcow-dockerapi-mailcow"
      "mailcow-dovecot-mailcow"
      "mailcow-memcached-mailcow"
      "mailcow-mysql-mailcow"
      "mailcow-netfilter-mailcow"
      "mailcow-nginx-mailcow"
      "mailcow-php-fpm-mailcow"
      "mailcow-postfix-mailcow"
      "mailcow-redis-mailcow"
      "mailcow-rspamd-mailcow"
      "mailcow-sogo-mailcow"
      "mailcow-unbound-mailcow"
      "mailcow-watchdog-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
      "--privileged"
      "--security-opt=label=disable"
    ];
  };
  systemd.services."podman-mailcow-ipv6nat-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-memcached-mailcow" = {
    image = "memcached:alpine";
    environment = {
      "TZ" = "";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=memcached-mailcow"
      "--network=mailcow_mailcow-network:alias=memcached"
    ];
  };
  systemd.services."podman-mailcow-memcached-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-mysql-mailcow" = {
    image = "mariadb:10.11";
    environment = {
      "MYSQL_DATABASE" = "";
      "MYSQL_INITDB_SKIP_TZINFO" = "1";
      "MYSQL_PASSWORD" = "";
      "MYSQL_ROOT_PASSWORD" = "";
      "MYSQL_USER" = "";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/conf/mysql:/etc/mysql/conf.d:ro,Z"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_mysql-vol-1:/var/lib/mysql:rw"
    ];
    ports = [
      "127.0.0.1:13306:3306/tcp"
    ];
    dependsOn = [
      "mailcow-netfilter-mailcow"
      "mailcow-unbound-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mysql-mailcow"
      "--network=mailcow_mailcow-network:alias=mysql"
    ];
  };
  systemd.services."podman-mailcow-mysql-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_mysql-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_mysql-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-netfilter-mailcow" = {
    image = "ghcr.io/mailcow/netfilter:1.61";
    environment = {
      "DISABLE_NETFILTER_ISOLATION_RULE" = "n";
      "IPV4_NETWORK" = "172.22.1";
      "IPV6_NETWORK" = "fd4d:6169:6c63:6f77::/64";
      "MAILCOW_REPLICA_IP" = "";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SNAT6_TO_SOURCE" = "n";
      "SNAT_TO_SOURCE" = "n";
      "TZ" = "";
    };
    volumes = [
      "/lib/modules:/lib/modules:ro"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=host"
      "--privileged"
    ];
  };
  systemd.services."podman-mailcow-netfilter-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-nginx-mailcow" = {
    image = "ghcr.io/mailcow/nginx:1.03";
    environment = {
      "ADDITIONAL_SERVER_NAMES" = "";
      "DISABLE_IPv6" = "n";
      "HTTPS_PORT" = "443";
      "HTTP_PORT" = "80";
      "HTTP_REDIRECT" = "n";
      "IPV4_NETWORK" = "172.22.1";
      "MAILCOW_HOSTNAME" = "";
      "NGINX_USE_PROXY_PROTOCOL" = "n";
      "PHPFPMHOST" = "";
      "REDISHOST" = "";
      "RSPAMDHOST" = "";
      "SKIP_RSPAMD" = "n";
      "SKIP_SOGO" = "n";
      "SOGOHOST" = "";
      "TRUSTED_PROXIES" = "";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/conf/dovecot/auth/mailcowauth.php:/mailcowauth/mailcowauth.php:rw,z"
      "/etc/oci.cont/mailcow/data/conf/nginx:/etc/nginx/conf.d:rw,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/dynmaps:/dynmaps:ro,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/meta_exporter:/meta_exporter:ro,z"
      "/etc/oci.cont/mailcow/data/web:/web:ro,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.auth.inc.php:/mailcowauth/functions.auth.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.inc.php:/mailcowauth/functions.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/sessions.inc.php:/mailcowauth/sessions.inc.php:rw,z"
      "mailcow_sogo-web-vol-1:/usr/lib/GNUstep/SOGo:rw"
    ];
    ports = [
      "443:443/tcp"
      "80:80/tcp"
    ];
    dependsOn = [
      "mailcow-php-fpm-mailcow"
      "mailcow-redis-mailcow"
      "mailcow-rspamd-mailcow"
      "mailcow-sogo-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=nginx-mailcow"
      "--network=mailcow_mailcow-network:alias=nginx"
    ];
  };
  systemd.services."podman-mailcow-nginx-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_sogo-web-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_sogo-web-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-ofelia-mailcow" = {
    image = "mcuadros/ofelia:latest";
    environment = {
      "COMPOSE_PROJECT_NAME" = "mailcow";
      "TZ" = "";
    };
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    cmd = ["daemon" "--docker" "-f" "label=com.docker.compose.project=mailcow"];
    labels = {
      "ofelia.enabled" = "true";
    };
    dependsOn = [
      "mailcow-dovecot-mailcow"
      "mailcow-sogo-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=ofelia-mailcow"
      "--network=mailcow_mailcow-network:alias=ofelia"
      "--security-opt=label=disable"
    ];
  };
  systemd.services."podman-mailcow-ofelia-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-olefy-mailcow" = {
    image = "ghcr.io/mailcow/olefy:1.15";
    environment = {
      "OLEFY_BINDADDRESS" = "0.0.0.0";
      "OLEFY_BINDPORT" = "10055";
      "OLEFY_DEL_TMP" = "1";
      "OLEFY_LOGLVL" = "20";
      "OLEFY_MINLENGTH" = "500";
      "OLEFY_OLEVBA_PATH" = "/usr/bin/olevba";
      "OLEFY_PYTHON_PATH" = "/usr/bin/python3";
      "OLEFY_TMPDIR" = "/tmp";
      "SKIP_OLEFY" = "n";
      "TZ" = "";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=olefy-mailcow"
      "--network=mailcow_mailcow-network:alias=olefy"
    ];
  };
  systemd.services."podman-mailcow-olefy-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-php-fpm-mailcow" = {
    image = "ghcr.io/mailcow/phpfpm:1.93";
    environment = {
      "ADDITIONAL_SERVER_NAMES" = "";
      "ALLOW_ADMIN_EMAIL_LOGIN" = "n";
      "API_ALLOW_FROM" = "invalid";
      "API_KEY" = "invalid";
      "API_KEY_READ_ONLY" = "invalid";
      "CLUSTERMODE" = "";
      "COMPOSE_PROJECT_NAME" = "mailcow";
      "DBNAME" = "";
      "DBPASS" = "";
      "DBUSER" = "";
      "DEMO_MODE" = "n";
      "DEV_MODE" = "n";
      "IMAPS_PORT" = "993";
      "IMAP_PORT" = "143";
      "IPV4_NETWORK" = "172.22.1";
      "IPV6_NETWORK" = "fd4d:6169:6c63:6f77::/64";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "MAILCOW_PASS_SCHEME" = "BLF-CRYPT";
      "MASTER" = "y";
      "POPS_PORT" = "995";
      "POP_PORT" = "110";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SIEVE_PORT" = "4190";
      "SKIP_CLAMD" = "n";
      "SKIP_FTS" = "y";
      "SKIP_OLEFY" = "n";
      "SKIP_SOGO" = "n";
      "SMTPS_PORT" = "465";
      "SMTP_PORT" = "25";
      "SUBMISSION_PORT" = "587";
      "TZ" = "";
      "WEBAUTHN_ONLY_TRUSTED_VENDORS" = "n";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/assets/templates:/tpls:rw,z"
      "/etc/oci.cont/mailcow/data/conf/dovecot/auth/mailcowauth.php:/mailcowauth/mailcowauth.php:rw,z"
      "/etc/oci.cont/mailcow/data/conf/dovecot/global_sieve_after:/global_sieve/after:rw,z"
      "/etc/oci.cont/mailcow/data/conf/dovecot/global_sieve_before:/global_sieve/before:rw,z"
      "/etc/oci.cont/mailcow/data/conf/nginx:/etc/nginx/conf.d:rw,z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/crons:/crons:rw,z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/php-conf.d/opcache-recommended.ini:/usr/local/etc/php/conf.d/opcache-recommended.ini:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/php-conf.d/other.ini:/usr/local/etc/php/conf.d/zzz-other.ini:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/php-conf.d/upload.ini:/usr/local/etc/php/conf.d/upload.ini:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/php-fpm.d/pools.conf:/usr/local/etc/php-fpm.d/z-pools.conf:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/phpfpm/sogo-sso:/etc/sogo-sso:rw,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/custom:/rspamd_custom_maps:rw,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/dynmaps:/dynmaps:ro,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/meta_exporter:/meta_exporter:ro,z"
      "/etc/oci.cont/mailcow/data/conf/sogo:/etc/sogo:rw,z"
      "/etc/oci.cont/mailcow/data/hooks/phpfpm:/hooks:rw,Z"
      "/etc/oci.cont/mailcow/data/web:/web:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.acl.inc.php:/mailcowauth/functions.acl.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.auth.inc.php:/mailcowauth/functions.auth.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.inc.php:/mailcowauth/functions.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.mailbox.inc.php:/mailcowauth/functions.mailbox.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/functions.ratelimit.inc.php:/mailcowauth/functions.ratelimit.inc.php:rw,z"
      "/etc/oci.cont/mailcow/data/web/inc/sessions.inc.php:/mailcowauth/sessions.inc.php:rw,z"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_rspamd-vol-1:/var/lib/rspamd:rw"
    ];
    cmd = ["php-fpm" "-d" "date.timezone=" "-d" "expose_php=0"];
    labels = {
      "ofelia.enabled" = "true";
      "ofelia.job-exec.phpfpm_keycloak_sync.command" = "/bin/bash -c \"php /crons/keycloak-sync.php || exit 0\"";
      "ofelia.job-exec.phpfpm_keycloak_sync.no-overlap" = "true";
      "ofelia.job-exec.phpfpm_keycloak_sync.schedule" = "@every 1m";
      "ofelia.job-exec.phpfpm_ldap_sync.command" = "/bin/bash -c \"php /crons/ldap-sync.php || exit 0\"";
      "ofelia.job-exec.phpfpm_ldap_sync.no-overlap" = "true";
      "ofelia.job-exec.phpfpm_ldap_sync.schedule" = "@every 1m";
    };
    dependsOn = [
      "mailcow-redis-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=php-fpm-mailcow"
      "--network=mailcow_mailcow-network:alias=phpfpm"
    ];
  };
  systemd.services."podman-mailcow-php-fpm-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-postfix-mailcow" = {
    image = "ghcr.io/mailcow/postfix:1.80";
    environment = {
      "DBNAME" = "";
      "DBPASS" = "";
      "DBUSER" = "";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SPAMHAUS_DQS_KEY" = "";
      "TZ" = "";
    };
    volumes = [
      # "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/conf/postfix:/opt/postfix/conf:rw,z"
      "/etc/oci.cont/mailcow/data/hooks/postfix:/hooks:rw,Z"
      "mailcow_crypt-vol-1:/var/lib/zeyple:rw"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_postfix-vol-1:/var/spool/postfix:rw"
      "mailcow_rspamd-vol-1:/var/lib/rspamd:rw"
    ];
    ports = [
      "25:25/tcp"
      "465:465/tcp"
      "587:587/tcp"
    ];
    dependsOn = [
      "mailcow-mysql-mailcow"
      "mailcow-unbound-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_BIND_SERVICE"
      "--dns=172.22.1.254"
      "--ip=172.22.1.253"
      "--network-alias=postfix-mailcow"
      "--network=mailcow_mailcow-network:alias=postfix"
    ];
  };
  systemd.services."podman-mailcow-postfix-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_crypt-vol-1.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_postfix-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_crypt-vol-1.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_postfix-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-redis-mailcow" = {
    image = "redis:7.4.2-alpine";
    environment = {
      "REDISMASTERPASS" = "";
      "REDISPASS" = "";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/conf/redis/redis-conf.sh:/redis-conf.sh:rw,z"
      "mailcow_redis-vol-1:/data:rw"
    ];
    ports = [
      "127.0.0.1:7654:6379/tcp"
    ];
    dependsOn = [
      "mailcow-netfilter-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--entrypoint=[\"/bin/sh\", \"/redis-conf.sh\"]"
      "--ip=172.22.1.249"
      "--network-alias=redis-mailcow"
      "--network=mailcow_mailcow-network:alias=redis"
      "--sysctl=net.core.somaxconn=4096"
    ];
  };
  systemd.services."podman-mailcow-redis-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_redis-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_redis-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-rspamd-mailcow" = {
    image = "ghcr.io/mailcow/rspamd:2.2";
    environment = {
      "IPV4_NETWORK" = "172.22.1";
      "IPV6_NETWORK" = "fd4d:6169:6c63:6f77::/64";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SPAMHAUS_DQS_KEY" = "";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/conf/rspamd/custom:/etc/rspamd/custom:rw,z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/local.d:/etc/rspamd/local.d:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/lua:/etc/rspamd/lua:ro,Z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/override.d:/etc/rspamd/override.d:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/plugins.d:/etc/rspamd/plugins.d:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/rspamd.conf.local:/etc/rspamd/rspamd.conf.local:rw,Z"
      "/etc/oci.cont/mailcow/data/conf/rspamd/rspamd.conf.override:/etc/rspamd/rspamd.conf.override:rw,Z"
      "/etc/oci.cont/mailcow/data/hooks/rspamd:/hooks:rw,Z"
      "mailcow_rspamd-vol-1:/var/lib/rspamd:rw"
    ];
    dependsOn = [
      "mailcow-clamd-mailcow"
      "mailcow-dovecot-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--hostname=rspamd"
      "--network-alias=rspamd-mailcow"
      "--network=mailcow_mailcow-network:alias=rspamd"
    ];
  };
  systemd.services."podman-mailcow-rspamd-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-sogo-mailcow" = {
    image = "ghcr.io/mailcow/sogo:1.133";
    environment = {
      "ACL_ANYONE" = "disallow";
      "ALLOW_ADMIN_EMAIL_LOGIN" = "n";
      "DBNAME" = "";
      "DBPASS" = "";
      "DBUSER" = "";
      "IPV4_NETWORK" = "172.22.1";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "MAILCOW_PASS_SCHEME" = "BLF-CRYPT";
      "MASTER" = "y";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "SKIP_SOGO" = "n";
      "SOGO_EXPIRE_SESSION" = "480";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/conf/sogo:/etc/sogo:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-favicon.ico:/usr/lib/GNUstep/SOGo/WebServerResources/img/sogo.ico:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-fulllogo.png:/usr/lib/GNUstep/SOGo/WebServerResources/img/sogo-logo.png:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-fulllogo.svg:/usr/lib/GNUstep/SOGo/WebServerResources/img/sogo-full.svg:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-shortlogo.svg:/usr/lib/GNUstep/SOGo/WebServerResources/img/sogo-compact.svg:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-sogo.js:/usr/lib/GNUstep/SOGo/WebServerResources/js/custom-sogo.js:rw,z"
      "/etc/oci.cont/mailcow/data/conf/sogo/custom-theme.js:/usr/lib/GNUstep/SOGo/WebServerResources/js/theme.js:rw,z"
      "/etc/oci.cont/mailcow/data/hooks/sogo:/hooks:rw,Z"
      "/etc/oci.cont/mailcow/data/web/inc/init_db.inc.php:/init_db.inc.php:rw,z"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_sogo-userdata-backup-vol-1:/sogo_backup:rw"
      "mailcow_sogo-web-vol-1:/sogo_web:rw"
    ];
    labels = {
      "ofelia.enabled" = "true";
      "ofelia.job-exec.sogo_backup.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu sogo /usr/sbin/sogo-tool backup /sogo_backup ALL || exit 0\"";
      "ofelia.job-exec.sogo_backup.schedule" = "@every 24h";
      "ofelia.job-exec.sogo_ealarms.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu sogo /usr/sbin/sogo-ealarms-notify -p /etc/sogo/cron.creds || exit 0\"";
      "ofelia.job-exec.sogo_ealarms.schedule" = "@every 1m";
      "ofelia.job-exec.sogo_eautoreply.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu sogo /usr/sbin/sogo-tool update-autoreply -p /etc/sogo/cron.creds || exit 0\"";
      "ofelia.job-exec.sogo_eautoreply.schedule" = "@every 5m";
      "ofelia.job-exec.sogo_sessions.command" = "/bin/bash -c \"[[ \${MASTER} == y ]] && /usr/local/bin/gosu sogo /usr/sbin/sogo-tool -v expire-sessions \${SOGO_EXPIRE_SESSION} || exit 0\"";
      "ofelia.job-exec.sogo_sessions.schedule" = "@every 1m";
    };
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--ip=172.22.1.248"
      "--network-alias=sogo-mailcow"
      "--network=mailcow_mailcow-network:alias=sogo"
    ];
  };
  systemd.services."podman-mailcow-sogo-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_sogo-userdata-backup-vol-1.service"
      "podman-volume-mailcow_sogo-web-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_sogo-userdata-backup-vol-1.service"
      "podman-volume-mailcow_sogo-web-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-unbound-mailcow" = {
    image = "ghcr.io/mailcow/unbound:1.24";
    environment = {
      "SKIP_UNBOUND_HEALTHCHECK" = "n";
      "TZ" = "";
    };
    volumes = [
      "/etc/oci.cont/mailcow/data/conf/unbound/unbound.conf:/etc/unbound/unbound.conf:ro,Z"
      "/etc/oci.cont/mailcow/data/hooks/unbound:/hooks:rw,Z"
    ];
    log-driver = "journald";
    extraOptions = [
      "--ip=172.22.1.254"
      "--network-alias=unbound-mailcow"
      "--network=mailcow_mailcow-network:alias=unbound"
    ];
  };
  systemd.services."podman-mailcow-unbound-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };
  virtualisation.oci-containers.containers."mailcow-watchdog-mailcow" = {
    image = "ghcr.io/mailcow/watchdog:2.08";
    environment = {
      "ACME_THRESHOLD" = "1";
      "CHECK_UNBOUND" = "1";
      "CLAMD_THRESHOLD" = "15";
      "COMPOSE_PROJECT_NAME" = "mailcow";
      "DBNAME" = "";
      "DBPASS" = "";
      "DBROOT" = "";
      "DBUSER" = "";
      "DOVECOT_REPL_THRESHOLD" = "20";
      "DOVECOT_THRESHOLD" = "12";
      "EXTERNAL_CHECKS_THRESHOLD" = "1";
      "FAIL2BAN_THRESHOLD" = "1";
      "HTTPS_PORT" = "443";
      "IPV4_NETWORK" = "172.22.1";
      "IPV6_NETWORK" = "fd4d:6169:6c63:6f77::/64";
      "IP_BY_DOCKER_API" = "0";
      "LOG_LINES" = "9999";
      "MAILCOW_HOSTNAME" = "";
      "MAILQ_CRIT" = "30";
      "MAILQ_THRESHOLD" = "20";
      "MYSQL_REPLICATION_THRESHOLD" = "1";
      "MYSQL_THRESHOLD" = "5";
      "NGINX_THRESHOLD" = "5";
      "OLEFY_THRESHOLD" = "5";
      "PHPFPM_THRESHOLD" = "5";
      "POSTFIX_THRESHOLD" = "8";
      "RATELIMIT_THRESHOLD" = "1";
      "REDISPASS" = "";
      "REDIS_SLAVEOF_IP" = "";
      "REDIS_SLAVEOF_PORT" = "";
      "REDIS_THRESHOLD" = "5";
      "RSPAMD_THRESHOLD" = "5";
      "SKIP_CLAMD" = "n";
      "SKIP_LETS_ENCRYPT" = "n";
      "SKIP_OLEFY" = "n";
      "SKIP_SOGO" = "n";
      "SOGO_THRESHOLD" = "3";
      "TZ" = "";
      "UNBOUND_THRESHOLD" = "5";
      "USE_WATCHDOG" = "n";
      "WATCHDOG_EXTERNAL_CHECKS" = "n";
      "WATCHDOG_MYSQL_REPLICATION_CHECKS" = "n";
      "WATCHDOG_NOTIFY_BAN" = "y";
      "WATCHDOG_NOTIFY_EMAIL" = "";
      "WATCHDOG_NOTIFY_START" = "y";
      "WATCHDOG_NOTIFY_WEBHOOK" = "";
      "WATCHDOG_NOTIFY_WEBHOOK_BODY" = "";
      "WATCHDOG_SUBJECT" = "Watchdog ALERT";
      "WATCHDOG_VERBOSE" = "n";
    };
    volumes = [
      # "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "/etc/oci.cont/mailcow/data/assets/ssl:/etc/ssl/mail:ro,z"
      "mailcow_mysql-socket-vol-1:/var/run/mysqld:rw"
      "mailcow_postfix-vol-1:/var/spool/postfix:rw"
      "mailcow_rspamd-vol-1:/var/lib/rspamd:rw"
    ];
    dependsOn = [
      "mailcow-acme-mailcow"
      "mailcow-dovecot-mailcow"
      "mailcow-mysql-mailcow"
      "mailcow-postfix-mailcow"
      "mailcow-redis-mailcow"
    ];
    log-driver = "journald";
    extraOptions = [
      "--dns=172.22.1.254"
      "--network-alias=watchdog-mailcow"
      "--network=mailcow_mailcow-network:alias=watchdog"
    ];
  };
  systemd.services."podman-mailcow-watchdog-mailcow" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_postfix-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    requires = [
      "podman-network-mailcow_mailcow-network.service"
      "podman-volume-mailcow_mysql-socket-vol-1.service"
      "podman-volume-mailcow_postfix-vol-1.service"
      "podman-volume-mailcow_rspamd-vol-1.service"
    ];
    partOf = [
      "podman-compose-mailcow-root.target"
    ];
    wantedBy = [
      "podman-compose-mailcow-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-mailcow_mailcow-network" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f mailcow_mailcow-network";
    };
    script = ''
      podman network inspect mailcow_mailcow-network || podman network create mailcow_mailcow-network --driver=bridge --opt=com.docker.network.bridge.name=br-mailcow --subnet=172.22.1.0/24 --subnet=fd4d:6169:6c63:6f77::/64 --ipv6
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };

  # Volumes
  systemd.services."podman-volume-mailcow_clamd-db-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_clamd-db-vol-1 || podman volume create mailcow_clamd-db-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_crypt-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_crypt-vol-1 || podman volume create mailcow_crypt-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_mysql-socket-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_mysql-socket-vol-1 || podman volume create mailcow_mysql-socket-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_mysql-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_mysql-vol-1 || podman volume create mailcow_mysql-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_postfix-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_postfix-vol-1 || podman volume create mailcow_postfix-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_redis-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_redis-vol-1 || podman volume create mailcow_redis-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_rspamd-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_rspamd-vol-1 || podman volume create mailcow_rspamd-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_sogo-userdata-backup-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_sogo-userdata-backup-vol-1 || podman volume create mailcow_sogo-userdata-backup-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_sogo-web-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_sogo-web-vol-1 || podman volume create mailcow_sogo-web-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_vmail-index-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_vmail-index-vol-1 || podman volume create mailcow_vmail-index-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };
  systemd.services."podman-volume-mailcow_vmail-vol-1" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect mailcow_vmail-vol-1 || podman volume create mailcow_vmail-vol-1
    '';
    partOf = ["podman-compose-mailcow-root.target"];
    wantedBy = ["podman-compose-mailcow-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-mailcow-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
