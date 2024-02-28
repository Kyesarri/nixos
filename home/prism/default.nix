{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    prism = {
      enable = true;
      wallpapers = "./home/prism/wallpapers"; # Path to the wallpapers directory in your config. (IMAGES ONLY)

      # There are a few different ways of setting the colorscheme.

      # If you pass the name it will use a lutgen builtin scheme
      colorscheme = "horizon-dark";

      # If you pass a list of colors, it will build a scheme from them.
      # They are formatted like base16 schemes
      # colorscheme = [ "FFFFFF" "FAFAFA" ... ];

      # You can also pass a nix-colors scheme attrset and it will parse the colors.
      # colorscheme = nix-colors.colorscheme.nord;
    };
  };
}
