{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."dots/config/swaync/config.json" = {
    text = ''
    '';
  };
}
