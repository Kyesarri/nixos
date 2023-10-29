# ./hosts/nix-laptop.nix
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
    ./laptop-hw.nix

    ../configuration.nix

    ../modules/gaming.nix
    ../modules/fonts.nix

    ../hardware/pipewire.nix

    ../home/home.nix
    ../home/hyprpaper.nix
    ../home/hyprland.nix
    ../home/waybar.nix
    ../home/kitty.nix
    ../home/wcp.nix
    ../home/wofi
    ../home/ags
    ../home/dunst
    ../home/lite-xl
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # uses base16 colours see here: https://github.com/tinted-theming/base16-schemes

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-laptop";
  networking.wireless.iwd.enable = true;
  systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  environment = {
    systemPackages = with pkgs; [pciutils];
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
    };
  };
}
# ./hosts/nix-laptop.nix

