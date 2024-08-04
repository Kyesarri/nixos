{
  secrets,
  lib,
  ...
}: let
  contName = "gate";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/minekube/gate:latest";

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}/config.yml:/config.yml"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.gate}"
    ];
  };

  environment.etc = {
    "oci.cont/${contName}/favicon.png" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./favicon.png;
    };
    "oci.cont/${contName}/config.yml" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      text = ''
        # gate proxy config

        # https://connect.minekube.com/

        connect:
          enabled: false
          name: yernar

        config:
          bind: 0.0.0.0:25565
          onlineMode: true

          servers:
            server1: ${secrets.ip.minecraft}:25565

          try:
            - server1

          status:
            # server image 64x64 base64 nintendo64
            favicon: ./favicon.png
            showMaxPlayers: 1000
            logPingRequests: true
            announceForge: false
            motd: |
              §b LETS VISIT
              §b➞ §f${secrets.domain.minecraft}

          acceptTransfers: false
          bungeePluginChannelEnabled: true
          builtinCommands: true
          requireBuiltinCommandPermissions: false
          announceProxyCommands: true
          forceKeyAuthentication: true

          shutdownReason: |
            §c${secrets.domain.minecraft} is going down...
            ...

          compression:
            threshold: 256
            level: -1

          connectionTimeout: 5s
          readTimeout: 30s
          failoverOnUnexpectedServerDisconnect: true
          onlineModeKickExistingPlayers: false
          debug: false

          forwarding:
            mode: legacy
            # velocitySecret: secret_here

          proxyProtocol: false

          quota:
            connections:
              enabled: true
              ops: 5
              burst: 10
              maxEntries: 1000
            logins:
              enabled: true
              burst: 3
              ops: 0.4
              maxEntries: 1000

          query:
            enabled: false
            port: 25577
            showPlugins: false

          auth:
            sessionServerUrl: https://sessionserver.mojang.com/session/minecraft/hasJoined

          lite:
            enabled: false
      '';
    };
  };
}
