{
  pkgs,
  user,
  ...
}: {
  imports = [
    #./config.jsonc.nix
    #./style.css.nix
  ];

  home-manager.users.${user} = {
    programs.wlogout = {
      enable = true;
    };
    home.file.".config/hypr/per-app/wlogout.conf" = {
      text = ''
        # wlogout test here
      '';
    };
  };
}
