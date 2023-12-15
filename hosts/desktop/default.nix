# ./hosts/nix-desktop.nix
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
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix # adds device specific setting for hypr (monitor / machine specific binds)

      ../standard.nix
      ./hardware.nix

      ../../hardware/audio
      ../../hardware/bluetooth
      ../../hardware/nvidia
      ../../hardware/rgb
      ../../hardware/wireless

      ../../home
      ../../home/codium
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
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-desktop";

    services = {
      xserver = {
        enable = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
      };
    };
  }
# ./hosts/nix-desktop.nix

