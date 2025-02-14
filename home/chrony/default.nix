{secrets, ...}: {
  services.chrony = {
    enable = true;
    enableNTS = false;
    serverOption = "iburst";
    directory = "/var/lib/chrony";
    servers = [
      "0.au.pool.ntp.org"
      "1.pool.ntp.org"
      "time2.google.com"
      "3.oceania.pool.ntp.org"
      "nz.pool.ntp.org"
    ];
    extraConfig = ''allow ${secrets.ip.subnet}/${secrets.ip.mask}'';
  };
}
