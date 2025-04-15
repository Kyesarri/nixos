{secrets, ...}: {
  # v basic config using zerotier root servers
  # working on ztnet for local hosting
  services.zerotierone = {
    enable = true;
    joinNetworks = ["${secrets.zerotier.network1}"];
    port = 9993;
  };
}
