# https://nixos.wiki/wiki/NixOS_modules
{
  pkgs,
  spaghetti,
  ...
}: {
  # TODO add nix-colors to bottom.toml.nix
  # TODO don't add new nix mkOption pls
  imports = [./bottom.toml.nix];

  users.users.${spaghetti.user}.packages = with pkgs; [bottom]; # enables the package

  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/bottom.conf" = {
      text = ''
        # bottom uses per-app in foot / kitty / fish / zsh congfig currently
      '';
    };
  };
}
