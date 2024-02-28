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
    spaghetti,
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
      ../../hardware/wireless/wpa

      ../../home
      ../../home/ags
      ../../home/bottom
      ../../home/codium
      ../../home/copyq
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/gaming
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
      ../../home/zsh
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking = {
      defaultGateway = {
        address = "192.168.87.251";
        interface = "enp3s0";
      };
      hostName = "nix-desktop";

      wireless.iwd.settings = {
        General = {EnableNetworkConfiguration = true;};
        Network = {EnableIPv6 = false;};
      };

      interfaces.enp3s0.ipv4 = {
        addresses = [
          {
            address = "192.168.87.220";
            prefixLength = 24;
          }
        ];
        #routes = [
        #  {
        #    address = "192.168.87.0";
        #    prefixLength = 24;
        #    via = "192.168.87.251";
        #  }
        #];
      };
    };

    services = {
      xserver = {
        enable = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-desktop --show-trace";
    };
  }
