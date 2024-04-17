{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker = {enable = true;};

  environment.systemPackages = with pkgs; [docker-compose intel-gpu-tools];

  networking = {
    nat.enable = true;
    useDHCP = false; # for host?
    bridges.br0.interfaces = ["eno1"]; # serv bridge #1
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.251"];
    interfaces = {
      #
      "br0" = {
        useDHCP = true; # bridged devices use dhcp by default
        ipv4.addresses = [
          {
            address = "192.168.87.9"; # bridge ip?
            prefixLength = 24;
          }
        ];
      };
      #
      "enp5s0" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.87.10"; # testing realtek m.2 e 2.5g card in serv
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
