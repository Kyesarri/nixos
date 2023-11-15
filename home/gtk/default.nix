{ config, pkgs, inputs, nix-colors, ... }:

let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in rec {
  gtk = {
    enable = true;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorScheme; };
    };
  };
}

