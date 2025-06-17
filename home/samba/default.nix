/*
https://nixos.wiki/wiki/Samba
TODO move this config to serv, add some basic lad
configs for samba to be imported as an option
*/
{secrets, ...}: {
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    settings = {
      # todo - move all these drives on serv under one dir
      # import single dir on erying...
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
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };

      "hddb" = {
        "path" = "/hddb";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddc" = {
        "path" = "/hddc";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddd" = {
        "path" = "/hddd";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hdde" = {
        "path" = "/hdde";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddf" = {
        "path" = "/hddf";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddg" = {
        "path" = "/hddg";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddh" = {
        "path" = "/hddh";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
      "hddi" = {
        "path" = "/hddi";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
    };
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };
}
