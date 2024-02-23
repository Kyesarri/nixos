let
  #scheme = "tokyo-night-storm";
  scheme = "horizon-dark"; # new hotness
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
      ../../hardware/wireless/nwm # networkmanager # TODO this is shit, look into mkOption

      ../../home
      ../../home/ags # TODO pam / menu /
      ../../home/asusctl # TODO look into issues with this further
      ../../home/bottom
      ../../home/codium # TODO build custom theme to use, with nix-colors. # TODO pin versions to avoid compiling
      ../../home/copyq # TODO change to an alternative
      ../../home/dunst # ags has own notification daemon, will require fixing brightness scripts
      ../../home/firefox # why you always need to build from source, check to see if there are nighty / beta precompiled
      ../../home/git
      ../../home/gaming
      ../../home/hypr # TODO remove wallpaper hyprwal?
      # ../../home/kde # meh
      ../../home/kitty
      ../../home/ulauncher # TODO rename built theme, add credits to og author
      ../../home/virt
      ../../home/gtk
      ../../home/syncthing # TODO fix not launching at boot
      ../../home/tailscale
      #../../home/wallpaper
      # ../../home/wlogout # removed, will use AGS remember to add AGS to PAM
      ../../home/zsh
    ];

    hardware.nvidia = {
      # PCI-Express Runtime D3 Power Management is enabled by default on this laptop
      # Enable DRM kernel mode setting
      prime = {
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
      };
    };

    #boot.kernelParams = [
    #  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    #  "nvidia-drm.modeset=1"
    #]; # trying to fix suspend problem on nvidia

    # nix-colors
    colorscheme = inputs.nix-colors.colorSchemes.${scheme};
    home-manager.users.${user}.colorscheme = inputs.nix-colors.colorSchemes.${scheme};

    networking.hostName = "nix-laptop";

    programs = {
      # from flake
      auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            governor = "performance";
            turbo = "auto";
          };

          battery = {
            governor = "powersave";
            turbo = "auto";
          };
        };
      };
    };

    services = {
      # fprintd.enable = true; # fprint reader, needs work for this model
      xserver.enable = true;
      udev.extraHwdb = ''
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
        KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
        KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
      '';
    };

    environment = {
      systemPackages = with pkgs; [pciutils];
      shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${user}/nixos#nix-laptop --show-trace -j 16 && hyprctl reload && ./ags.sh";
    };
  }
