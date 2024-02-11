{
  inputs,
  outputs,
  pkgs,
  user,
  config,
  ...
}: {
  imports = [./colours.css.nix];

  users.users.${user}.packages = [pkgs.python3];

  home-manager.users.${user} = {
    programs.ags.enable = true; # still need to enable the package
    # TODO editing directly from .config to avoid so-many rebuilds :D
    # home.file.".config/ags/" = {
    #   source = ./config; # symlink whole ~/nixos/home/ags/config dir, leaving some other files to nix, for nix-colors passthrough
    #   recursive = true; # all subfolders and files
    # };
    # add back once ags is mainline # TODO sync current changes to cbg / ghub
    home.file.".config/hypr/per-app/ags.conf" = {
      text = ''
        exec-once = ~/nixos/scripts/ags.sh
      '';
    };
  };
}
