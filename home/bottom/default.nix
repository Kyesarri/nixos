{
  pkgs,
  spaghetti,
  ...
}: {
  imports = [./bottom.toml.nix];

  users.users.${spaghetti.user}.packages = with pkgs; [bottom]; # enable btm

  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/bottom.conf" = {
      text = ''
        # btm uses per-app in foot / kitty / fish / zsh congfig currently
      '';
    };
  };
}
