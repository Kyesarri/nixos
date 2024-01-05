{
  pkgs,
  user,
  ...
}: {
  imports = [
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
        windowrulev2 = animation snappy, class:^(wlogout)$
      '';
    };
    home.file."./.config/wlogout/power.png".source = ./power.png;
    #home-manager.users.${user}.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;
    #home-manager.users.${user}.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;
    #home-manager.users.${user}.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;
    #home-manager.users.${user}.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;
    #home-manager.users.${user}.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;
  };
}
