{user, ...}: {
  home-manager.users.${user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,1920x1080@120,auto,1
      bindl =, switch:on[Lid Switch], exec, swaylock --screenshots --effect-blur 20x1
    '';
  };
}
