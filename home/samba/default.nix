/*
https://nixos.wiki/wiki/Samba
*/
{secrets, ...}: {
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smb-serv";
        "netbios name" = "smb-serv";
        "security" = "user";

        "guest account" = "nobody";
        "map to guest" = "bad user";

        "hosts allow" = "192.168.87. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };

      "hdda" = {
        "path" = "/hdda";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "force user" = "1000";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };

      "hddb" = {
        "path" = "/hddb";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "force user" = "1000";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
    };
  };
}
