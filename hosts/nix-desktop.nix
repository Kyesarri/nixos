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
      inputs.nix-colors.homeManagerModules.default
      ./shared.nix
      ./desktop-hw.nix

      ../configuration.nix

      ../modules/gaming.nix
      ../modules/fonts.nix

      ../hardware/pipewire.nix
      ../hardware/openrgb.nix
      ../hardware/nvidia.nix

      ../home/home.nix
      ../home/waybar.nix
      ../home/kitty.nix
      ../home/wofi
      ../home/dunst
      ../home/lite-xl
      ../home/hypr
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    hardware.bluetooth.enable = true;
    networking.hostName = "nix-desktop";
    networking.wireless.iwd.enable = true;

    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };

    environment = {
      systemPackages = with pkgs; [i2c-tools pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
      };
    };
  }
# ./hosts/nix-desktop.nix

