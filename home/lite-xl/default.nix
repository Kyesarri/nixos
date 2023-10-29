{
  config,
  ...
}:
{
  home-manager.users.kel.home.file."./.config/lite-xl/plugins/language_nix".source = ./language_nix; # hard to use a .js in nix so symlink works for me
}
