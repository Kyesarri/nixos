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
  };
}
