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
    ./containers.nix
    ./hardware.nix
    ./networking.nix

    ../headless.nix

    ../../hardware

    ../../home
    ../../home/bottom
    ../../home/git
    ../../home/gtk
    ../../home/kitty
    ../../home/syncthing
    ../../home/tmux
    ../../home/zsh
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking.hostName = "nix-ws";

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.seahorse];
    };
    xserver.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [pciutils usbutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-ws --show-trace";
  };
}
