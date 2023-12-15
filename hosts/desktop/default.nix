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

      ../../hardware/pipewire.nix
      ../../hardware/openrgb.nix
      ../../hardware/nvidia.nix
      ../../hardware/bluetooth
      ../../hardware/wireless
      ../../hardware/audio

      ../../home
      ../../home/ags
      ../../home/codium
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kde
      ../../home/kitty
      ../../home/lite-xl
      ../../home/swaync
      ../../home/waybar
      ../../home/wcp
      ../../home/wofi
      ../../home/ulauncher
      ../../home/virt
      ../../home/gtk
      ../../home/syncthing
      ../../home/tailscale
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    users.users.kel.packages = with pkgs; [nvtop]; # ./hardware/nvidia

    networking.hostName = "nix-desktop";

    services = {
      ratbagd.enable = true; # ./home/gaming and or ./hardware/gaming
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
      };
    };

    environment = {
      systemPackages = with pkgs; [i2c-tools pciutils]; # ./hardware/openrgb/ i2c-tools only
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
      };
    };
  }
# ./hosts/nix-desktop.nix

