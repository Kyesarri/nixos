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
    defaultTimeout = 5;
    icons = true;
    textColor = "#${config.colorscheme.colors.base05}";
    backgroundColor = "#${config.colorscheme.colors.base01}";
    borderColor = "#${config.colorscheme.colors.base03}";
  };
}
