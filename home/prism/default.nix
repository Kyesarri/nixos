# TODO: mkOption this, add configurables for directories with notes and such
{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    prism = {
      enable = true;
      wallpapers = ./wallpapers; # relative path, could use ../../ to escape into homedir if wanted
      outPath = "/wallpapers"; # from root of /users/currentuser/
      colorscheme = [
        "#${config.colorscheme.palette.base00}"
        "#${config.colorscheme.palette.base01}"
        "#${config.colorscheme.palette.base02}"
        "#${config.colorscheme.palette.base03}"
        "#${config.colorscheme.palette.base04}"
        "#${config.colorscheme.palette.base05}"
        "#${config.colorscheme.palette.base06}"
        "#${config.colorscheme.palette.base07}"
        "#${config.colorscheme.palette.base08}"
        "#${config.colorscheme.palette.base09}"
        "#${config.colorscheme.palette.base0A}"
        "#${config.colorscheme.palette.base0B}"
        "#${config.colorscheme.palette.base0C}"
        "#${config.colorscheme.palette.base0D}"
        "#${config.colorscheme.palette.base0E}"
        "#${config.colorscheme.palette.base0F}"
      ];
    };
  };
}
