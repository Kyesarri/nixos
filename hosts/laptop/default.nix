{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  spaghetti,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
    ./per-device.nix
    ./hardware.nix

    ../standard.nix

    ../../hardware/audio
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/nvidia
    ../../hardware/wireless/nwm # networkmanager # TODO this is shit, look into mkOption

    #../../home/changedetection # easy fix

    # TODO # are completed as to mkoption, are enabled / configured via gnocchi.pkg.enable = true;
    ../../home/ags # TODO pam / menu
    ../../home/hypr # TODO remove wallpaper hyprwal?
    ../../home/gscreenshot
    # TODO # are completed as to mkoption, are enabled / configured via gnocchi.pkg.enable = true;

    ../../home # set some default values for home-manager
    ../../home/asusctl # TODO look into issues with this further
    ../../home/bottom # task-manager
    ../../home/codium # TODO build custom theme to use, with nix-colors. # TODO pin versions to avoid compiling
    ../../home/copyq # TODO change to an alternative
    ../../home/dunst # ags has own notification daemon, will require fixing brightness scripts
    ../../home/firefox # why you always need to build from source, check to see if there are nighty / beta precompiled
    ../../home/git
    ../../home/gaming
    ../../home/greetd
    #
    ../../home/kitty # /home/shell/ under mkOption, have foot / kitty / more? in there
    #
    ../../home/kde # TODO rename kdeconnect
    ../../home/nebula
    ../../home/ulauncher # TODO rename built theme, add credits to og author
    ../../home/virt
    ../../home/gtk # uhh, nix-colors gtk theme iirc
    ../../home/prism
    ../../home/syncthing # TODO fix not launching at boot
    ../../home/tailscale
    ../../home/zsh
  ];

  boot.supportedFilesystems = ["ntfs"];

  gnocchi = {
    ags.enable = true;
    gscreenshot.enable = true;
    hypr = {
      enable = true;
      hyprpaper.enable = false;
      # isNvidia = true; # nvidia
      # animations = false;
    };
    # wireless = { /* networking.wireless? */
    #   enable = true;
    #   manager = nwm; # nwm, iwd or wpa
    # };
  };

  hardware.nvidia = {
    prime = {
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
    };
  };

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking.hostName = "nix-laptop";

  programs = {
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
    # fprintd.enable = true;
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
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-laptop --show-trace -j 16 && cd ~ && hyprctl reload && ./ags.sh";
  };
}
