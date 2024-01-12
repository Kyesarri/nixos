let
  scheme = "snazzy";
  home = "../../home/";
  cont = "../../containers/";
  hardware = "../../hardware/"; # not working :)
in
  {
    config,
    pkgs,
    lib,
    inputs,
    outputs,
    nix-colors,
    user,
    plymouth_theme, # eeeeehhh not sure if this is needed :)
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix # per device hypr config
      ./hardware.nix # device specific hardware config

      ../headless.nix # base packages, not really "headless" yet

      ../../containers # testing nixos containers, all container packages imported by /containers/default.nix currently

      ################## could use per-device to import wanted containers or even import containers in here
      ################## leaving /containers/default.nix as just the networking config / basic container confg?
      ################## could look something like the following:
      # ../../containers
      # ../../containers/nextcloud
      # ../../containers/haos
      ################## config this way would be similar formatting to how i have the rest of my configs
      ################## might be the best way forward
      ################## added line to make symmetrical :)

      ../../hardware/audio # probs worthwile for warning sounds or something
      ../../hardware/battery # this server comes with its own built-in "ups"
      ../../hardware/wireless # wont be required for long, moving to m.2 ethernet

      ../../home # home-manaager config
      ################## below packages come with prebaked configs, hypr bindings and probably candy
      ../../home/bottom
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kitty
      ../../home/lite-xl
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/gtk
      
      # ../../home/syncthing # testing without currently
      # ../../home/tailscale
      # ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
    wireless.networks = {
      "Stolen Telstra Modem" = { hidden = false; }; };
      firewall.allowedTCPPorts = [22]; # ssh, possibly open already but leaving in
      hostName = "nix-serv";
      defaultGateway = "192.168.87.251";
      #interfaces.wlan0.ipv4.addresses = [
    #{ address = "192.168.87.9"; prefixLength = 24; }
  #];
    };

    services = {
      tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 65; # 80 and above it stops charging

      };
};
      xserver.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-serv --show-trace";
    };
  }
