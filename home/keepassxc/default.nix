{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: {
  # launch keepassxc with hyprland
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/keepassxc.conf".text = ''
    exec-once = keepassxc
    windowrulev2 = size 700 300, class:^(org.keepassxc.KeePassXC)$
    windowrulev2 = float, class:^(org.keepassxc.KeePassXC)$
    windowrulev2 = bordercolor $cc, class:^(org.keepassxc.KeePassXC)$


    ${config.colorscheme.palette.base0C}

  '';

  # enable keepassxc
  users.users.${spaghetti.user}.packages = [pkgs.keepassxc];

  # make keepass our dbus package - by default keepass will require a password to unlock - i prefer this atm
  services.dbus = {
    enable = true;
    packages = [pkgs.keepassxc];
  };
}
