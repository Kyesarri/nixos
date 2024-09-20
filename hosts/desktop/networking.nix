{secrets, ...}: {
  networking = {
    hostName = "nix-desktop";
    defaultGateway = {
      address = "${secrets.ip.gateway}";
      interface = "enp3s0";
    };
    interfaces.enp3s0.ipv4 = {
      addresses = [
        {
          address = "${secrets.ip.desktop}";
          prefixLength = 24;
        }
      ];
    };
  };
}
