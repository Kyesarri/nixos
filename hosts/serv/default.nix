let
  scheme = "snazzy";
in
  {
    config,
    pkgs,
    lib,
    inputs,
    outputs,
    nix-colors,
    user,
    plymouth_theme,
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix

      ../headless.nix
      ./hardware.nix

      ../../hardware/audio
      ../../hardware/battery
      ../../hardware/wireless

      ../../home
      ../../home/bottom
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kitty
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/gtk
      ../../home/syncthing
      ../../home/tailscale
      ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
      hostName = "nix-serv";
      firewall.allowedTCPPorts = [22]; # ssh
    };

    services = {
      xserver.enable = true;
      power-profiles-daemon.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-serv --show-trace";
    };
  }
