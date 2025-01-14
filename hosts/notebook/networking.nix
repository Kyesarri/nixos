{...}: {
  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # fixes connection issues with tailscale
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
      8080 # ustreamer
    ];

    allowedUDPPorts = [
    ];
  };
}
