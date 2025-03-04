{
  config,
  secrets,
  ...
}: {
  networking.firewall.allowedTCPPorts = [4000 4001];
  networking.firewall.allowedUDPPorts = [4000 4001];
  /*
  services.nfs.server = {
    enable = true;
    # hostName = ""; # defaults to all hostNames?
    statdPort = 4000;
    lockdPort = 4001;
    exports = ''
      /hdda ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddb ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddc ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddd ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hdde ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddf ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddh ${secrets.ip.range}/24(ro,sync,no_subtree_check)
      /hddi ${secrets.ip.range}/24(ro,sync,no_subtree_check)
    '';
  };
  */
}
