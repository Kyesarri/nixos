{
  secrets,
  lib,
  ...
}: let
  contName = "gate";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/minekube/gate:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.gate}"
    ];
  };

  environment.etc = {
    # create symlinks in /etc - not sure if we can only write to paths relative to /etc

    # symlink file from nix tree to our container dir
    # "oci.cont/${contName}/favicon.png".source = [./favicon.png];

    # write our config to desired location
    "oci.cont/${contName}/config.yml".text = ''
      # gate proxy config

      # https://connect.minekube.com/

      connect:
        enabled: false
        name: yernar

      config:
        bind: 0.0.0.0:25565
        onlineMode: true

        servers:
          server1: ${toString secrets.ip.minecraft}

        try:
          - server1

        status:
          # server image 64x64 base64 nintendo64
          favicon: favicon.png
          showMaxPlayers: 1000
          logPingRequests: true
          announceForge: false
          motd: |
            §b LETS VISIT
            §b➞ §f${toString secrets.domain.minecraft}

        acceptTransfers: false
        bungeePluginChannelEnabled: true
        builtinCommands: true
        requireBuiltinCommandPermissions: false
        announceProxyCommands: true
        forceKeyAuthentication: true

        shutdownReason: |
          §c${toString secrets.domain.minecraft} is going down...
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
          routes:
            - host: localhost
              backend: localhost:25566
              fallback:
                motd: |
                  §cLocalhost server is offline.
                  §eCheck back later!
                version:
                  name: '§cTry again later!'
                  protocol: -1
                favicon:
            - host: '*.example.com'
              backend: 172.16.0.12:25566
              proxyProtocol: true # Use proxy protocol to connect to backend.
              tcpShieldRealIP: true # Optionally you can also use TCPShield's RealIP protocol.
            - host: [ 127.0.0.1, localhost ]
              backend: [ 172.16.0.12:25566, backend.example.com:25566 ]
              cachePingTTL: 60s
              modifyVirtualHost: true
            - host: '*'
              backend: 10.0.0.10:25565
              fallback:
                motd: §eNo server available for this host.
                version:
                  name: §eTry example.com
                  protocol: -1
    '';
  };
}
