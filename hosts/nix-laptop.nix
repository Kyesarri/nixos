# ./hosts/nix-laptop.nix
let
  scheme = "tokyo-night-dark";
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
      ./standard.nix
      ./laptop-hw.nix

      ../hardware/pipewire.nix

      ../home
      ../home/ags
      ../home/codium
      ../home/dunst
      ../home/firefox
      ../home/git
      ../home/hypr
      ../home/kde
      ../home/kitty
      ../home/lite-xl
      ../home/swaync
      ../home/ulauncher
      ../home/waybar
      ../home/wcp
      ../home/wofi
      ../home/gtk
    ];
    # define colours scheme for standard and home manager packages, theme set at top of file
    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    # needed to define for packages in and outside of home-manager
    users.users.kel.packages = with pkgs; [nvtop qemu];

    hardware.bluetooth.enable = true;
    networking.hostName = "nix-laptop";
    networking.wireless.iwd.enable = true;
    systemd.services.supergfxd.path = [pkgs.pciutils]; # gpu switching

    services.xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };

    services.fprintd.enable = true; # TODO merge all services
    services.ratbagd.enable = true; # mouse settings thing?

    services.upower = {
      enable = true; # using upower for battery monitoring, waybar needs some configuration for this too
      percentageCritical = 10;
      percentageLow = 15;
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
      };
    };
  }
# ./hosts/nix-laptop.nix

