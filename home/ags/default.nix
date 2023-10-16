{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel = {
    imports = [inputs.ags.homeManagerModules.default]; # imports from root flake.nix then builds the package which is nice :)
    programs.ags = {
      enable = true; # still need to enable the package
      configDir = ./ags; # sets to /home/kel/dots/config/ags
    };
  };
}
