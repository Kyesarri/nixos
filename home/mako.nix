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
    enable = true; # TODO notification service, needs more work, just using OOBE currently
    anchor = "bottom-center";
    defaultTimeout = 5;
    icons = true;
    textColor = "#${config.colorscheme.colors.base05}";
    backgroundColor = "#${config.colorscheme.colors.base01}";
    borderColor = "#${config.colorscheme.colors.base03}";
  };
}
