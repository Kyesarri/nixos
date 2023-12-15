# ./hosts/nix-notebook.nix
let
  scheme = "material-darker";
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

      ../minimal.nix
      ./hardware.nix

      ../../hardware/battery
      ../../hardware/bluetooth
      ../../hardware/wireless
      ../../hardware/audio

      ../../home
      ../../home/foot
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/lite-xl
      ../../home/waybar
      ../../home/gtk
      ../../home/ulauncher
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-notebook";

    services.xserver = {
      enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-notebook --show-trace";
      };
    };
  }
# ./hosts/nix-notebook.nix

