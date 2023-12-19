let
  scheme = "tokyo-night-dark";
in
  {
    config,
    pkgs,
    lib,
    inputs,
    outputs,
    nix-colors,
    user,
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix

      ../standard.nix
      ./hardware.nix

      ../../hardware/audio
      ../../hardware/battery
      ../../hardware/bluetooth
      ../../hardware/nvidia
      ../../hardware/wireless

      ../../home
      ../../home/codium
      ../../home/copyq
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kde
      ../../home/kitty
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/gtk
      ../../home/syncthing
      ../../home/tailscale
      ../../home/wallpaper
      ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-laptop";

    systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

    services = {
      fprintd.enable = true; # fprint reader, needs work for this model
      xserver.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-laptop --show-trace";
      shellAliases.remrebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-laptop --show-trace --builders 'ssh://nix-desktop x86_64-linux'";
    };
  }
