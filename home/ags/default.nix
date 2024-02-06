{
  inputs,
  outputs,
  pkgs,
  user,
  config,
  ...
}: {
  imports = [./style.css.nix]; # TODO lots to work on here

  home-manager.users.${user} = {
    programs.ags.enable = true; # still need to enable the package
    home.file.".config/ags/" = {
      source = ./config; # symlink whole ~/nixos/home/ags/config dir, leaving some other files to nix, for nix-colors passthrough
      recursive = true; # all subfolders and files
    };
    # add back once ags is mainline
    #    home.file.".config/hypr/per-app/ags.conf" = {
    #      text = ''
    #        exec-once = ags
    #      '';
    #    };
  };
}
