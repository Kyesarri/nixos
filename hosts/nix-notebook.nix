# ./hosts/nix-notebook.nix
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
      ./shared.nix
      ./notebook-hw.nix

      ../hardware/pipewire.nix

      ../home
      ../home/dunst
      ../home/firefox
      ../home/git
      ../home/hypr
      ../home/kde
      ../home/kitty
      ../home/lite-xl
      ../home/swaync
      ../home/waybar
      ../home/wcp
      ../home/wofi
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
  }
# ./hosts/nix-notebook.nix

