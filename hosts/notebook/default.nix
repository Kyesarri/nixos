{
  pkgs,
  inputs,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./per-device.nix
    ./hardware.nix
    ./boot.nix

    ../headless.nix

    ../../hardware
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/audio

    ../../home
    ../../home/bottom
    ../../home/git
    ../../home/gtk
    ../../home/kitty
    ../../home/syncthing
    ../../home/fwedee
    ../../home/zsh
  ];

  gnocchi = {
    wifi.backend = "nwm";
  };

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking.hostName = "nix-notebook";

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.seahorse];
    };
    xserver.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [pciutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-notebook --show-trace";
  };
}
