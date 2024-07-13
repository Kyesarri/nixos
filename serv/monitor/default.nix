# taken parts from: https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
let
  serv = {
    grafana = {
      webPort = 2342;
      httpAddr = "0.0.0.0";
      domain = "grafana.home";
    };
    prometheus = {
      port = 9001;
    };
  };
in
  {config, ...}: {
    # grafana configuration
    networking.firewall.allowedTCPPorts = [serv.grafana.webPort serv.prometheus.port];

    services.grafana = {
      enable = true;
      settings.server = {
        # domain = "${serv.grafana.domain}";
        http_port = serv.grafana.webPort;
        http_addr = "${serv.grafana.httpAddr}";
      };
    };

    services.prometheus = {
      enable = true;
      port = serv.prometheus.port;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };
      scrapeConfigs = [
        {
          job_name = "nix-serv";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
      ];
    };

    # nginx reverse proxy
    services.nginx.virtualHosts.${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  }
