{
  lib,
  secrets,
  ...
}: {
  # open us some ports on host
  networking.firewall.allowedTCPPorts = [2049 4000 4001 4002 20048];
  networking.firewall.allowedUDPPorts = [2049 4000 4001 4002 20048];

  # create /export dir, set perms
  system.activationScripts.makeNFSDir = lib.stringAfter ["var"] ''mkdir -v -p /export & chown nobody:nogroup /export'';

  # create bind-mounts on host, add to /exports/*
  # brute-force all, there is a more elegant way to do this ;)
  fileSystems = {
    "/export/hdda" = {
      device = "/hdda";
      options = ["bind"];
    };
    "/export/hddb" = {
      device = "/hddb";
      options = ["bind"];
    };
    "/export/hddc" = {
      device = "/hddc";
      options = ["bind"];
    };
    "/export/hddd" = {
      device = "/hddd";
      options = ["bind"];
    };
    "/export/hddee" = {
      device = "/hdde";
      options = ["bind"];
    };
    "/export/hddf" = {
      device = "/hddf";
      options = ["bind"];
    };
    "/export/hddg" = {
      device = "/hddg";
      options = ["bind"];
    };
    "/export/hddh" = {
      device = "/hddh";
      options = ["bind"];
    };
    "/export/hddi" = {
      device = "/hddi";
      options = ["bind"];
    };
  };

  services.nfs.server = {
    enable = true;
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;

    # setup nfs shares, again there is a more elegant method to achieve this
    # mounts on other devices cannot open dirs, more #TODO
    exports = ''
      /export/hdda ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddb ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddc ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddd ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hdde ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddf ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddg ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddh ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /export/hddi ${secrets.ip.range}/24(ro,sync,no_subtree_check)
    '';
  };
}
