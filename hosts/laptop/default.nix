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

      ../../hardware/pipewire.nix

      ../../home
      ../../home/ags
      ../../home/codium
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/kde
      ../../home/kitty
      ../../home/swaync
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/wcp
      ../../home/wofi
      ../../home/gtk
      ../../home/syncthing
      ../../home/tailscale
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    users.users.kel.packages = with pkgs; [nvtop];

    hardware.bluetooth.enable = true; # TODO bluetooth ./hardware
    networking.hostName = "nix-laptop";
    networking.wireless.iwd.enable = true;
    systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

    services = {
      fprintd.enable = true;
      ratbagd.enable = true; # TODO gaming
      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
      };
      upower = {
        # TODO ./hardware battery
        enable = true;
        percentageCritical = 10;
        percentageLow = 15;
      };
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
      };
    };
  }
# ./hosts/nix-laptop.nix

