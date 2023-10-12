# disabled due to theming not working, may be due to custom xdg config dir
{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.services.mako = {
    enable = true; # TODO more needs to be done here, looks pretty scratchy atm
    anchor = "bottom-center"; # config not working?
    defaultTimeout = 5; # has to do with directory hm writes to
    icons = true; # not true, shits just not right...
    textColor = "#${config.colorscheme.colors.base05}";
    backgroundColor = "#${config.colorscheme.colors.base01}";
    borderColor = "#${config.colorscheme.colors.base03}";
  };
}
