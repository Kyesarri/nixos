{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.pciutils pkgs.supergfxctl];

  /*
  environment.etc."supergfxd.conf" = {
    mode = "0644";
    source = (pkgs.formats.json {}).generate "supergfxd.conf" {
      vfio_enable = false;
      vfio_save = false;
      always_reboot = false;
      no_logind = true;
      logout_timeout_s = 180;
      hotplug_type = "Asus";
    };
  };
  */
  systemd = {
    services = {
      supergfxd.path = [pkgs.pciutils]; # gpu switching
      power-profiles-daemon = {
        enable = true;
        wantedBy = ["multi-user.target"];
      };
    };
  };

  services = {
    power-profiles-daemon.enable = true;
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig.text = builtins.readFile ./asusd.ron;
    };
  };

  # below not required
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/asusd.conf".text = ''
    exec-once = sleep 3 && rog-control-center
  '';
}
