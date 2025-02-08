{...}: {
  services.chrony = {
    enable = true;
    enableNTS = false;
    servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.pool.ntp.org"
    ];
    serverOption = "iburst";
  };
}
