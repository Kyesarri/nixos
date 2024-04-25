# taken parts from: https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
# hosts/chrysalis/configuration.nix
{
  config,
  pkgs,
  ...
}: {
  # grafana configuration
  networking.firewall.allowedTCPPorts = [2342];

  services.grafana = {
    enable = true;
    settings.server = {
      # domain = "grafana.home";
      http_port = 2342;
      http_addr = "0.0.0.0";
    };
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
