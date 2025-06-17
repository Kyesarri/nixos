/*
this lad getting messy
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

  /*
  security.wrappers."mount.cifs" = {
    program = "mount.cifs";
    source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
    owner = "root";
    group = "root";
    setuid = true;
  };
  */

  fileSystems = {
    "/mnt/storage" = {
      device = "//${secrets.ip.serv-1}/storage";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
    };
  };
}
