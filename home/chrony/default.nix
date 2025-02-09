{secrets, ...}: {
  # need
  services.chrony = {
    enable = true;
    enableNTS = false;
    serverOption = "iburst";
    directory = "/var/lib/chrony";
    servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.pool.ntp.org"
      "3.ntp.per.nml.csiro.au"
    ];
    extraConfig = ''allow ${secrets.ip.subnet}/${secrets.ip.mask}'';
  };
}
