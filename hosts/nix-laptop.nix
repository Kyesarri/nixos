# ./hosts/nix-laptop.nix
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: 
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in 

{
# should majority of these be imported by shared, then any system specific added into the desktop / laptop configs?
# will do on next refactor
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./shared.nix
    ./laptop-hw.nix

    ../configuration.nix
    ../modules/gaming.nix
    ../modules/fonts.nix

    ../hardware/pipewire.nix

    ../home
    ../home/waybar
    ../home/kitty
    ../home/wcp
    ../home/wofi
    ../home/ags
    ../home/dunst
    ../home/lite-xl
    ../home/hypr
    ../home/gtk
  ];
  
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

