{
  pkgs,
  user,
  ...
}: {
  users.users.${user}.packages = [pkgs.pciutils];

  services.asusd = {
    enable = true;
    # enableUserService = true;
  };

  services.supergfxd.enable = true;

  systemd = {
    services.supergfxd.path = [pkgs.pciutils]; # gpu switching
    # sleep.extraConfig = "HibernateMode=hybrid-sleep"; # testing workaround for nvidia sleep issues
  };

  # these are not? required.
  home-manager.users.${user}.home.file.".config/hypr/per-app/asusd.conf" = {
    text = ''
      # this is already a system service, dont need to start
      # exec-once = systemctl start asusd
      # run battery level at every boot
      # if this service has a moment run "systemctl start asusd", hopefully that fixes things
      exec-once = sleep 3 && asusctl -c 75
    '';
  };
}
