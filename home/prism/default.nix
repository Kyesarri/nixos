{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    prism = {
      enable = true;
      # wallpapers = "/home/${spaghetti.user}/nixos/wallpapers"; # Path to the wallpapers directory in your config. (IMAGES ONLY)
      wallpapers = ./wallpapers; # Path to the wallpapers directory in your config. (IMAGES ONLY)
      colorscheme = "horizon-dark";
      outPath = ".config/wallpapers";
      # outPath = ".config/wallpapers";

      # If you pass a list of colors, it will build a scheme from them.
      # They are formatted like base16 schemes
      # colorscheme = [ "FFFFFF" "FAFAFA" ... ];

      # You can also pass a nix-colors scheme attrset and it will parse the colors.
      # colorscheme = nix-colors.colorscheme.nord;
    };
  };
}
