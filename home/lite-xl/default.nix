{
  config,
  ...
}:
{
  home-manager.users.kel.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua; # sym link
  imports = [
    ./config.nix
    ./style.nix
    ./configSchema.nix
  ];
}
