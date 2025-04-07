# Auto-generated using compose2nix v0.3.1.
{
  pkgs,
  lib,
  ...
}: {
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };

  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53];

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."postgres" = {
    image = "postgres:15.2-alpine";
    environment = {
      "POSTGRES_DB" = "ztnet";
      "POSTGRES_PASSWORD" = "postgres";
      "POSTGRES_USER" = "postgres";
    };
    volumes = [
      "ztnet_postgres-data:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=postgres"
      "--network=ztnet_app-network"
    ];
  };
  systemd.services."podman-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_postgres-data.service"
    ];
    requires = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_postgres-data.service"
    ];
    partOf = [
      "podman-compose-ztnet-root.target"
    ];
    wantedBy = [
      "podman-compose-ztnet-root.target"
    ];
  };
  virtualisation.oci-containers.containers."zerotier" = {
    image = "zyclonite/zerotier:1.14.2";
    environment = {
      "ZT_ALLOW_MANAGEMENT_FROM" = "172.31.255.0/29";
      "ZT_OVERRIDE_LOCAL_CONF" = "true";
    };
    volumes = [
      "ztnet_zerotier:/var/lib/zerotier-one:rw"
    ];
    ports = [
      "9993:9993/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--hostname=zerotier"
      "--network-alias=zerotier"
      "--network=ztnet_app-network"
    ];
  };
  systemd.services."podman-zerotier" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_zerotier.service"
    ];
    requires = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_zerotier.service"
    ];
    partOf = [
      "podman-compose-ztnet-root.target"
    ];
    wantedBy = [
      "podman-compose-ztnet-root.target"
    ];
  };
  virtualisation.oci-containers.containers."ztnet" = {
    image = "sinamics/ztnet:latest";
    environment = {
      "NEXTAUTH_SECRET" = "random_secret";
      "NEXTAUTH_URL" = "http://localhost:3000";
      "NEXTAUTH_URL_INTERNAL" = "http://ztnet:3000";
      "POSTGRES_DB" = "ztnet";
      "POSTGRES_HOST" = "postgres";
      "POSTGRES_PASSWORD" = "postgres";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "postgres";
    };
    volumes = [
      "ztnet_zerotier:/var/lib/zerotier-one:rw"
    ];
    ports = [
      "3000:3000/tcp"
    ];
    dependsOn = [
      "postgres"
      "zerotier"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=ztnet"
      "--network=ztnet_app-network"
    ];
  };
  systemd.services."podman-ztnet" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_zerotier.service"
    ];
    requires = [
      "podman-network-ztnet_app-network.service"
      "podman-volume-ztnet_zerotier.service"
    ];
    partOf = [
      "podman-compose-ztnet-root.target"
    ];
    wantedBy = [
      "podman-compose-ztnet-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-ztnet_app-network" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f ztnet_app-network";
    };
    script = ''
      podman network inspect ztnet_app-network || podman network create ztnet_app-network --driver=bridge --subnet=172.31.255.0/29
    '';
    partOf = ["podman-compose-ztnet-root.target"];
    wantedBy = ["podman-compose-ztnet-root.target"];
  };

  # Volumes
  systemd.services."podman-volume-ztnet_postgres-data" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect ztnet_postgres-data || podman volume create ztnet_postgres-data
    '';
    partOf = ["podman-compose-ztnet-root.target"];
    wantedBy = ["podman-compose-ztnet-root.target"];
  };
  systemd.services."podman-volume-ztnet_zerotier" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect ztnet_zerotier || podman volume create ztnet_zerotier
    '';
    partOf = ["podman-compose-ztnet-root.target"];
    wantedBy = ["podman-compose-ztnet-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-ztnet-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
