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

      ../headless.nix # base packages, not really "headless"

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
      ## below packages come with prebaked configs, hypr bindings and probably candy
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
      ../../home/tailscale
      ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
      hostName = "nix-serv";
      firewall.allowedTCPPorts = [22]; # ssh, possibly open already but leaving in
    };

    services = {
      xserver.enable = true;
      power-profiles-daemon.enable = true; # power profile management, might be nice to script for low power / perf schedules
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-serv --show-trace";
    };
  }
