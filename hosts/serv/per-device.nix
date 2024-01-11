{user, ...}: {
  home-manager.users.${user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,3840x1600@75,auto,1
      bind = $mainMod, l, exec, swaylock --screenshots --effect-blur 3x5 --fade-in 0.7 --effect-vignette 0.1:0.8
    '';
  };
}
