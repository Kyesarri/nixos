{
  spaghetti,
  pkgs,
  ...
}: {
  # enable keepassxc
  users.users.${spaghetti.user}.packages = [pkgs.keepassxc];

  # launch keepassxc with hyprland
  # add window rules and launch binding
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/keepassxc.conf".text = ''
    exec-once = keepassxc
    windowrulev2 = size 800 550, class:^(org.keepassxc.KeePassXC)$
    windowrulev2 = float, class:^(org.keepassxc.KeePassXC)$
    windowrulev2 = bordercolor $cc, class:^(org.keepassxc.KeePassXC)$
    bind = $mainMod, z, exec, keepassxc
  '';

  # make keepassxc our dbus package
  services.dbus = {
    enable = true;
    packages = [pkgs.keepassxc];
  };
}
