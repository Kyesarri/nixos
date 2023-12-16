# ./hosts/nix-laptop.nix
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
      ../../hardware/battery
      ../../hardware/bluetooth
      ../../hardware/nvidia
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
      ../../home/wallpaper
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-laptop";

    systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

    services = {
      fprintd.enable = true; # fprint reader, needs work for this model
      xserver.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
      };
    };
  }
# ./hosts/nix-laptop.nix

