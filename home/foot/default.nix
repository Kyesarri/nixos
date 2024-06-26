{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.foot];

  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/foot.conf" = {
    text = ''
      windowrulev2 = opacity 0.8 0.8, class:^(foot)$
      windowrulev2 = size 700 300, class:^(foot)$
      bind = $mainMod, Q, exec, foot
      bind = control, escape, exec, foot -e btm
      windowrulev2 = float, class:^(foot)$
    '';
  };
}
