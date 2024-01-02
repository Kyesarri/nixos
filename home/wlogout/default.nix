{
  pkgs,
  user,
  ...
}: {
  imports = [
    #./config.jsonc.nix
    #./style.css.nix
    ## currently wip, basic config enabled ##
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
