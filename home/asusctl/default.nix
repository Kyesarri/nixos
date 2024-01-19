{
  pkgs,
  user,
  ...
}: {
  users.users.${user}.packages = [pkgs.pciutils];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;

  systemd = {
    services.supergfxd.path = [pkgs.pciutils]; # gpu switching
    # sleep.extraConfig = "HibernateMode=hybrid-sleep"; # testing workaround for nvidia sleep issues
  };

  home-manager.users.${user}.home.file.".config/hypr/per-app/asusd.conf" = {
    text = ''
      exec-once = systemctl start asusd
      exec-once = sleep 3 && asusctl -c 75
    '';
  };
}
