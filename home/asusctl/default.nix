{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.pciutils pkgs.supergfxctl];

  systemd = {
    services.supergfxd.path = [pkgs.pciutils]; # gpu switching
    # sleep.extraConfig = "HibernateMode=hybrid-sleep"; # testing workaround for nvidia sleep issues
    # don't believe ^ is required any longer, may have been fixed by hypr
  };

  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  # this fucking thing, always seems to break for no good reason
  # really want to get rid of this and have something that will
  # work without too many hitches on my machine
  #
  # pending re-enabling userservice and idk somemthing else

  # these are not? required.
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/asusd.conf" = {
    text = ''
      # this is already a system service, dont need to start
      # exec-once = systemctl start asusd
      # run battery level at every boot
      # if this service has a moment run "systemctl start asusd", hopefully that fixes things
      exec-once = sleep 3 && asusctl -c 75 && rog-control-center
    '';
  };
}
