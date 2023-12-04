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
      ./standard.nix
      ./desktop-hw.nix

      ../hardware/pipewire.nix
      ../hardware/openrgb.nix
      ../hardware/nvidia.nix

      ../home
      ../home/ags
      ../home/codium
      ../home/dunst
      ../home/firefox
      ../home/git
      ../home/hypr
      ../home/kde
      ../home/kitty
      ../home/lite-xl
      ../home/swaync
      ../home/waybar
      ../home/wcp
      ../home/wofi
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    users.users.kel.packages = with pkgs; [nvtop];

    hardware.bluetooth.enable = true;
    networking.hostName = "nix-desktop";
    networking.wireless.iwd.enable = true;

    services = {
      ratbagd.enable = true; # mouse settings thing?

      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
      };
    };

    environment = {
      systemPackages = with pkgs; [i2c-tools pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
      };
    };
  }
# ./hosts/nix-desktop.nix

