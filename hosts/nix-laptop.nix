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
      # should majority of these be imported by shared, then any system specific added into the desktop / laptop configs?
      # unsure as, may need to change the nix.colors definitions to another file :)
      # not like this file is huge, overall pretty minimal
      nix-colors.homeManagerModules.default
      ./shared.nix
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
      ../home/waybar
      ../home/wcp
      ../home/wofi
    ];
    # define colours scheme for standard and home manager packages, theme set at top of file
    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.kel.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    hardware.bluetooth.enable = true;
    networking.hostName = "nix-laptop";
    networking.wireless.iwd.enable = true;
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

