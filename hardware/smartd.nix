#/etc/nixos/smartd.nix                                          

{ config, pkgs,lib,  ... }:

{
  services = {
    # Check S.M.A.R.T status of all disks and notify in case of errors
    smartd = {
      enable = true;
      # Monitor all devices connected to the machine at the time it's being started
      autodetect = true;
      notifications = {
        x11.enable = if config.services.xserver.enable then true else false;
        wall.enable = true; # send wall notifications to all users

      }; # notifications

    }; # smartd
 
  }; # services
}
