/*
this lad getting messy, need to fix mount as root fml
*/
{
  spaghetti,
  secrets,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.cifs-utils];

  services.samba.enable = true;

  fileSystems = {
    "/mnt/storage" = {
      device = "//${secrets.ip.serv-1}/storage";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=989";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
    };
  };
}
