{secrets, ...}: {
  # need
  services.chrony = {
    enable = true;
    enableNTS = false;
    servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.pool.ntp.org"
    ];
    serverOption = "iburst";
    directory = "/var/lib/chrony";
    extraConfig = [
      # example
      # "allow 192.168.0.1/24"
      "allow ${secrets.ip.subnet}/${secrets.ip.mask}"
    ];
  };
}
