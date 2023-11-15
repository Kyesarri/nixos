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
# should majority of these be imported by shared, then any system specific added into the desktop / laptop configs?
# will do on next refactor

  imports = [
    nix-colors.homeManagerModules.default

    ./shared.nix
    ./laptop-hw.nix

    ../configuration.nix
    ../modules/gaming.nix
    ../modules/fonts.nix
    ../home

    ../hardware/pipewire.nix

      ../home/ags
      ../home/codium
      ../home/dunst
      ../home/firefox
      ../home/git
      #../home/gtk # out until i can figure out the function there
      ../home/hypr
      ../home/kde
      ../home/kitty
      ../home/lite-xl
      ../home/swaync
      ../home/waybar
      ../home/wcp
      ../home/wofi
  ];
colorscheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;


  
  hardware.bluetooth.enable = true;
  networking.hostName = "nix-laptop";
  networking.wireless.iwd.enable = true;
  systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  environment = {
    systemPackages = with pkgs; [ pciutils ];
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
    };
  };
}
# ./hosts/nix-laptop.nix

