# /etc/nixos/configuration.nix
{ config, pkgs,lib,  ... }:
{

  fonts = { # move to shared x86 / desktop and laptop, from a fresh install of nix without 
            # flakes this stops the install with errors
    packages = with pkgs; [
      material-design-icons
      inter
      material-symbols
      rubik
      ibm-plex
      (nerdfonts.override { fonts = [ "Iosevka" "CascadiaCode" "JetBrainsMono" ]; })
    ]; # packages
  }; # fonts

}
