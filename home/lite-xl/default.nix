{
  config,
  ...
}:
{
  home-manager.users.kel.home.file."./.config/lite-xl/plugins/nix.lua".source = .nix.lua; # hard to use a .js in nix so symlink works for me
}
