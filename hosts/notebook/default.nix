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
      ../minimal.nix
      ./hardware.nix

      .../hardware/pipewire.nix

      .../home
      .../home/dunst
      .../home/firefox
      .../home/git
      .../home/hypr
      .../home/lite-xl
      .../home/waybar
      .../home/gtk
      .../home/ulauncher
    ];

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    hardware.bluetooth.enable = true;
    networking.hostName = "nix-notebook";
    networking.wireless.iwd.enable = true;

    services.xserver = {
      enable = true;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-notebook --show-trace";
      };
    };

    services.upower = {
      enable = true; # using upower for battery monitoring, waybar needs some configuration for this too
      percentageCritical = 10; # TODO per device or own nix under ./home
      percentageLow = 15;
    };
  }
# ./hosts/nix-notebook.nix

