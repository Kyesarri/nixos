{user, ...}: {
  home-manager.users.${user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,1920x1080@120,auto,1
      bindl =, switch:Lid Switch, exec, swaylock --screenshots --effect-blur 3x5 --fade-in 0.7 --effect-vignette 0.1:0.8
      # bind = $mainMod, l, exec, swaylock --screenshots --effect-blur 3x5 --fade-in 0.7 --effect-vignette 0.1:0.8
    '';
  };
}
