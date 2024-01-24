{
  inputs,
  outputs,
  pkgs,
  user,
  config,
  ...
}: {
  imports = [./style.css.nix];
  home-manager.users.${user} = {
    programs.ags.enable = true; # still need to enable the package

    home.file.".config/ags/" = {
      source = ./config; # symlink whole ~/nixos/home/ags/config dir, leaving some other files to nix, for nix-colors passthrough
      recursive = true;
    };

    ### base0a is normally orange (other themes) its blue and the main highlight i use in toyyo-night-dark theme
    ### need to work on themes overall to get a more generalised theme applied
    ### that would look better across multiple base-16 themes
  };
}
