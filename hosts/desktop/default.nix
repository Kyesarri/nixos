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
      ../../home/ags
      ../../home/codium
      ../../home/dunst
      ../../home/firefox
      ../../home/gaming
      ../../home/git
      ../../home/gtk
      ../../home/hypr
      ../../home/kde
      ../../home/kitty
      ../../home/syncthing
      ../../home/tailscale
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
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
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
      };
    };
  }
# ./hosts/nix-desktop.nix

