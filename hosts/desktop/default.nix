{
  pkgs,
  inputs,
  secrets,
  spaghetti,
  nix-colors,
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
    ../../hardware/wireless/wpa # TODO please eventually fix this POS

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
    ../../home/gtk
    ../../home/syncthing
    ../../home/tailscale
    ../../home/zsh
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking = {
    defaultGateway = {
      address = "${secrets.ip.gateway}";
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
          address = "${secrets.ip.desktop}";
          prefixLength = 24;
        }
      ];
    };
  };

  services = {
    xserver = {
      enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      pciutils
      tailscale # lets users control tailscale
    ];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-desktop --show-trace";
  };
}
