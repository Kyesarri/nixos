{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [./style.nix];

  home-manager.users.kel.programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      always_parse_args = true;
      show_all = false;
      print_command = true;
      insensitive = true;
    };
  };
}
