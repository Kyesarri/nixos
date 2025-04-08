{
  pkgs,
  inputs,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./per-device.nix

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
    ../../home/tmux
    ../../home/fwedee
    ../../home/zsh
  ];

  gnocchi.wifi.backend = "nwm"; # isn't working?

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  networking.hostName = "nix-notebook";

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.seahorse];
    };
    xserver.enable = false; # may re-enable for klipperscreen
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  networking.networkmanager.enable = true;

  environment = {
    systemPackages = with pkgs; [pciutils usbutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-notebook --show-trace && cd ~";
  };
}
