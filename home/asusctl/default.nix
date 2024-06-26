{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.pciutils pkgs.supergfxctl];

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
      enableUserService = false;
      asusdConfig = ''
        (
          charge_control_end_threshold: 75,
          panel_od: false,
          mini_led_mode: false,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_policy_linked_epp: false,
          platform_policy_on_battery: Quiet,
          platform_policy_on_ac: Performance,
          ppt_pl1_spl: None,
          ppt_pl2_sppt: None,
          ppt_fppt: None,
          ppt_apu_sppt: None,
          ppt_platform_sppt: None,
          nv_dynamic_boost: None,
          nv_temp_target: None,
        )
      '';
    };
  };
  # below not required
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/asusd.conf".text = ''
    # this is already a system service, dont need to start
    # exec-once = systemctl start asusd
    # run battery level at every boot
    # if this service has a moment run "systemctl start asusd", hopefully that fixes things
    # disabled below, not sure if causing issues
    # exec-once = sleep 3 && asusctl -c 75 && rog-control-center
  '';
}
