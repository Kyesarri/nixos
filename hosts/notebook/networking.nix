{...}: {
  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # fixes connection issues with tailscale
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
      8080 # ustreamer nozzle-cam
      8081 # ustreamer bed-cam
      7125 # moonraker
      4409 # print? port
    ];

    allowedUDPPorts = [
    ];
  };
}
