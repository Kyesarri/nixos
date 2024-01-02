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
    user,
    plymouth_theme,
    ...
  }: {
    imports = [
      nix-colors.homeManagerModules.default
      ./per-device.nix

      ../standard.nix
      ./hardware.nix

      ../../hardware/audio
      ../../hardware/battery
      ../../hardware/bluetooth
      ../../hardware/nvidia
      ../../hardware/wireless

      ../../home
      ../../home/codium
      ../../home/copyq
      ../../home/dunst
      ../../home/firefox
      ../../home/git
      ../../home/gaming
      ../../home/hypr
      ../../home/kde
      ../../home/kitty
      ../../home/ulauncher
      ../../home/virt
      ../../home/waybar
      ../../home/gtk
      ../../home/syncthing
      ../../home/tailscale
      ../../home/wallpaper
      ../../home/wlogout
    ];

    hardware.nvidia = {
      # PCI-Express Runtime D3 Power Management is enabled by default on this laptop
      modesetting.enable = lib.mkDefault true;
      # Enable DRM kernel mode setting
      prime = {
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"]; # trying to fix suspend problem on nvidia

    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-laptop";

    systemd = {
      services.supergfxd.path = [pkgs.pciutils]; # gpu switching
      #sleep.extraConfig = "HibernateMode=hybrid-sleep"; # workaround for nvidia sleep issues
    };

    services = {
      fprintd.enable = true; # fprint reader, needs work for this model
      xserver.enable = true;
      asusd.enable = lib.mkDefault true;
      udev.extraHwdb = ''
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
        KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
        KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
      '';
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-laptop --show-trace";
    };
  }
