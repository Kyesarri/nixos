{secrets, ...}: {
  # need
  services.chrony = {
    enable = true;
    enableNTS = false;
    serverOption = "iburst";
    directory = "/var/lib/chrony";
    servers = [
      "0.au.pool.ntp.org"
      "1.pool.ntp.org"
      "ntp.per.nml.csiro.au"
    ];
    extraConfig = ''allow ${secrets.ip.subnet}/${secrets.ip.mask}'';
  };
}
