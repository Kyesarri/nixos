{
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/tailscale.conf" = {
    # hyprland run tailscale tray icon when launched
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

  users.users.${spaghetti.user}.packages = with pkgs; [
    tailscale # TODO is this req?
    tailscale-systray
  ];
}
