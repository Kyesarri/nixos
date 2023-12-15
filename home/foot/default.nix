{
  config,
  inputs,
  outputs,
  pkgs,
  nix-colors,
  ...
}: {
  users.users.kel.packages = with pkgs; [foot];

  home-manager.users.kel.home.file.".config/hypr/per-app/foot.conf" = {
    text = ''
      windowrulev2 = opacity 0.8 0.8, class:^(foot)$
      windowrulev2 = size 700 300, class:^(foot)$
      bind = $mainMod, Q, exec, foot
      bind = control, escape, exec, foot -e btm
      windowrule = float, title:zsh
    '';
  };
}
