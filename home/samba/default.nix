/*
https://nixos.wiki/wiki/Samba
*/
{}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "guest account" = "samba-guest";
        "map to guest" = "Bad User";
      };
      "hdda" = {
        "path" = "/hdda";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "force user" = "kel";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddb" = {
        "path" = "/hdda";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "force user" = "kel";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
    };
  };
}
