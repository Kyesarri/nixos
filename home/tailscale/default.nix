{
  config,
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file.".config/hypr/per-app/tailscale.conf" = {
    text = ''
      exec-once = sleep 2 && tailscale-systray
    '';
  };

  services = {
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
  };

  networking = {
    firewall = {
      checkReversePath = "loose"; # fixes some connection issues with tailscale
      allowedUDPPorts = [41641]; # tailscale
    };
  };

  users.users.${user}.packages = with pkgs; [
    tailscale
    tailscale-systray
  ];
}
