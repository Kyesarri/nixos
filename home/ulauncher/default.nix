{pkgs, ...}: {
  # these are for theme, TODO will be adding support for nix-colors soon :)
  #
  # TODO method for adding exec once = to hyprland config and binding to launch ulauncher, will be a nice-to-have for
  # ulancher and wofi, possibly other applications too
  # end goal is to enable applications in host.nix via import, package enabled, bindings and launch at login will be enabled
  # currently hard-coding each package in hyprland.conf which isn't ideal when multiple programs fill one use-case
  # functionality will be ideal for monitor resolutions on each device too
  #
  # see below for working config using wildcard in hypr.conf
  users.users.kel.packages = with pkgs; [ulauncher];

  home-manager.users.kel.home.file.".config/hypr/per-app/ulauncher.conf" = {
    text = ''
      exec-once = sleep 1 && ulauncher --hide-window
      windowrulev2 = noborder, class:^(ulauncher)$
      windowrulev2 = noshadow, class:^(ulauncher)$
      windowrulev2 = noblur, class:^(ulauncher)$
      bind = $mainMod, R, exec, ulauncher-toggle
    ''; ## fucking works, yee boi
  };

  imports = [
    ./manifest.json.nix
    ./theme-gtk-3.20.css.nix
    ./theme.css.nix
  ];
}
