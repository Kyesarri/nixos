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

      ../../containers # handles networking / bridge for host / containers
      ../../containers/frigate

      ../../hardware/audio # probs worthwile for warning sounds or something
      ../../hardware/battery # this server comes with its own built-in "ups"

      ../../home # home-manaager config for all machines currently
      ../../home/bottom
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kitty
      ../../home/codium
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/gtk

      # ../../home/syncthing # testing without currently
      ../../home/tailscale
      # ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
      hostName = "nix-serv";
      # moved most conf to ./containers/default.nix due to bridge conf
      firewall.allowedTCPPorts = [22]; # ssh, possibly open already but leaving in
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

          # optional helps save long term battery health
          ## using battery as ups for this machine :)
          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 65; # 65 and above it stops charging
          # unsure if these are actually applying on this system yet, do not believe so
        };
      };
      xserver.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-serv --show-trace";
    };
  }
