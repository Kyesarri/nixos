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
    user,
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix

      ../minimal.nix
      ./hardware.nix

      ../../hardware/battery
      ../../hardware/bluetooth
      ../../hardware/wireless
      ../../hardware/audio

      ../../home
      ../../home/bottom
      ../../home/foot
      ../../home/dunst
      ../../home/copyq
      ../../home/firefox
      ../../home/git
      ../../home/hypr
      ../../home/lite-xl
      ../../home/waybar
      ../../home/gtk
      ../../home/ulauncher
      ../../home/wlogout
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-notebook";

    services.xserver.enable = true;

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-notebook --show-trace";
    };
  }
