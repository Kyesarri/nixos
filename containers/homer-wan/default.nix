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

  environment.etc."oci.cont/${contName}/config.yml" = {
    mode = "644";
    uid = 1000;
    gid = 1000;
    text = ''
      ---
      # Homepage configuration
      # See https://fontawesome.com/v5/search for icons options

      title: "yur.mom"
      subtitle: "now on the internet"

      header: true
      footer: '<p> (づ ￣ ³￣)づ </p>'

      connectivityCheck: false
      defaults:
        layout: list
        colorTheme: dark

      links:
        - name: "homer - this page"
          icon: "fab fa-github"
          url: "https://github.com/bastienwirtz/homer"
        - name: "my nixos configs"
          icon: "fas fa-book"
          url: "https://codeberg.org/kye/nixos"
        # this will link to a second homer page that will load config from page2.yml and keep default config values as in config.yml file
        # see url field and assets/page.yml used in this example:
        # - name: "Second Page"
        #   icon: "fas fa-file-alt"
        #   url: "#page2"

      theme: neon
      colors:
        light:
          highlight-primary: "#E3E6EE" #
          highlight-secondary: "#B072D1" # banner divider, card tags
          highlight-hover: "#1C1E26" #
          background: "#E3E6EE" #
          card-background: "#DCDFE4" #
          text: "#1C1E26" #
          text-header: "#1C1E26" #
          text-title: "#1C1E26" #
          text-subtitle: "#1C1E26" #
          card-shadow: rgb(228, 163, 130, 0.7) # #24A8B4 also used on footer
          link: "#DF5273" # used for icons
          link-hover: "#E93C58" # hover icons
        dark:
          highlight-primary: "#232530" #
          highlight-secondary: "#B072D1" # banner divider, card tags
          highlight-hover: "#1C1E26" #
          background: "#1C1E26" #
          card-background: "#232530" #
          text: "#DCDFE4" #
          text-header: "#DCDFE4" #
          text-title: "#DCDFE4" #
          text-subtitle: "#DCDFE4" #
          card-shadow: rgb(228, 163, 130, 0.7) # #24A8B4 also used on footer
          link: "#DF5273" # used for icons
          link-hover: "#E93C58" # hover icons

      services:
        - name: "her things"
          icon: "fas fa-hand-holding-heart fa-fw"

          items:
            - name: "plex"
              icon: "fas fa-tv"
              subtitle: "mom's special movies"
              tag: "plex"
              url: "https://www.yur.mom/plex"

            - name: "request"
              icon: "fas fa-hand-middle-finger"
              subtitle: "now taking requests"
              tag: "overseerr"
              url: "https://www.yur.mom/request"

            - name: "minecraft"
              icon: "fas fa-cubes"
              subtitle: "break some bricks"
              tag: "minecraft"
              type: "CopyToClipboard"
              clipboard: "www.yur.mom"
    '';
  };

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
