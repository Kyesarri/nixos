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
      ./per-device.nix # per device hypr configuration

      ./hardware.nix # machine hardware config
      ../standard.nix # standard or minimal configs

      ../../hardware/audio # change to pipewire, move to home or change to av, prefer the latter
      ../../hardware/bluetooth
      ../../hardware/nvidia
      ../../hardware/rgb
      ../../hardware/wireless

      ../../home
      ../../home/bottom
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
      ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
      hostName = "nix-desktop";
      interfaces.enp3s0.ipv4.addresses = [
        {
          address = "192.168.87.200";
          prefixLength = 24;
        }
      ];
    };

    services = {
      xserver = {
        enable = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-desktop --show-trace";
    };
  }
