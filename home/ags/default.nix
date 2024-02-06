{
  inputs,
  outputs,
  pkgs,
  user,
  config,
  ...
}: {
  # imports = [./style.css.nix]; # TODO

  home-manager.users.${user} = {
    programs.ags.enable = true; # still need to enable the package
    home.file.".config/ags/" = {
      source = ./config; # symlink whole ~/nixos/home/ags/config dir, leaving some other files to nix, for nix-colors passthrough
      recursive = true; # all subfolders and files
    };
    # add back once ags is mainline
    #    home.file.".config/hypr/per-app/ags.conf" = {
    #      text = ''
    #        # exec=WAYLAND_DISPLAY=wayland-1 ags
    #        # fix from https://github.com/Aylur/ags/issues/75#issuecomment-1750083662
    #        # need to set env var WAYLAND_DISPLAY=wayland-1
    #        # issue might be ags config and not wayland / hyprland
    #        # exec-once = ags
    #      '';
    #    };
  };
}
