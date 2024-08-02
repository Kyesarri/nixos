{
  secrets,
  lib,
  ...
}: let
  contName = "homer-wan";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000 ${toString dir1}
  '';
  environment.etc."oci.cont/${contName}/config.yml".text = ''
    ---
    # Homepage configuration
    # See https://fontawesome.com/v5/search for icons options

    title: "yur.mom"
    subtitle: "now on the internet"
    logo: "logo.png"

    header: true
    footer: '<p> (づ ￣ ³￣)づ </p>'

    theme: default
    colors:
      light:
        highlight-primary: "#3367d6"
        highlight-secondary: "#4285f4"
        highlight-hover: "#5a95f5"
        background: "#f5f5f5"
        card-background: "#ffffff"
        text: "#363636"
        text-header: "#ffffff"
        text-title: "#303030"
        text-subtitle: "#424242"
        card-shadow: rgba(0, 0, 0, 0.1)
        link: "#3273dc"
        link-hover: "#363636"
      dark:
        highlight-primary: "#24A8B4" #
        highlight-secondary: "#B072D1" #
        highlight-hover: "#B072D1" #
        background: "#1C1E26" #
        card-background: "#232530" #
        text: "#CBCED0" #
        text-header: "#DCDFE4" #
        text-title: "#EFAF8E" #
        text-subtitle: "#E4A382" #
        card-shadow: rgba(0, 0, 0, 0.4)
        link: "#DF5273" #
        link-hover: "#E93C58" #

    # Services
    # First level array represent a group.
    # Leave only a "items" key if not using group (group name, icon & tagstyle are optional, section separation will not be displayed).
    services:
      - name: "services"
        items:
          - name: "plex"
            subtitle: "watch things"
            tag: "arr"
            url: "https://www.yur.mom/plex"

          - name: "overseerr"
            subtitle: "request things"
            tag: "arr"
            url: "https://www.yur.mom/request"

          - name: "minecraft"
            subtitle: "copy link, break blocks"
            tag: "gam"
            url: "www.yur.mom"
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "b4bz/homer:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/www/assets"
    ];

    environment = {};

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.homer-wan}"
    ];
  };
}
