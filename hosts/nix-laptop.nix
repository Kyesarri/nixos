# ./hosts/nix-laptop.nix
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
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
    # ../hardware/nvidia.nix # dont think this is required since im using nix hardware with drivers already enabled
    #
    # this is only for dots, might need refactor
    ../home/home.nix
    ../home/hyprpaper.nix
    ../home/hyprland.nix
    ../home/waybar.nix
    ../home/kitty.nix
    ../home/mako.nix
    ../home/wcp.nix
    # this is only for dots, might need refactor
    #
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # uses base16 colours see here: https://github.com/tinted-theming/base16-schemes

  # scheme: "Tokyo Night Dark"
  # author: "Michaël Ball"
  # base00: "1A1B26" very dark blue
  # base01: "16161E" blue black
  # base02: "2F3549" dark grey blue
  # base03: "444B6A" medium grey blue
  # base04: "787C99" light grey blue
  # base05: "A9B1D6" white blue pastel
  # base06: "CBCCD1" shell white
  # base07: "D5D6DB" another white
  # base08: "C0CAF5" another blue white
  # base09: "A9B1D6" white blue pastel
  # base0A: "0DB9D7" light blue pastel
  # base0B: "9ECE6A" light green pastel
  # base0C: "B4F9F8" very light blue pastel
  # base0D: "2AC3DE" blue pastel
  # base0E: "BB9AF7" purple pastel
  # base0F: "F7768E" red pastel

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-laptop";
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

