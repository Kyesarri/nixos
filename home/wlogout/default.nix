{
  pkgs,
  user,
  ...
}: {
  imports = [
    #./config.jsonc.nix
    ./style.css.nix
    ./layout.nix
  ];

  home-manager.users.${user} = {
    programs.wlogout = {
      enable = true;
    };
    home.file.".config/hypr/per-app/wlogout.conf" = {
      text = ''
        bind = $mainMod, L, exec, wlogout
        windowrulev2 = noanim, class:^(wlogout)$
      '';
    };
  };
}
