{nix-colors, ...}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./per-device.nix # hyprland per-device config
    ./hardware.nix # machine hardware
    ./boot.nix # per device boot config
    ./networking.nix # device networking configs

    ../standard.nix # template to use

    ../../hardware # not all hardware modules are required to be imported directly
    ../../hardware/audio
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/nvidia

    ../../home # set some default values for home-manager

    ../../home/cosmic # testing cosmic package - really fast!
    ../../home/asusctl # TODO look into issues with this further
    ../../home/bottom # task-manager
    ../../home/codium # TODO build custom theme to use, with nix-colors. # TODO pin versions to avoid compiling
    ../../home/copyq # TODO change to an alternative maybe?
    ../../home/dunst # ags has own notification daemon, will require fixing brightness scripts
    ../../home/firefox # why you always need to build from source, check to see if there are nighty / beta precompiled
    ../../home/git # add some basic git packages
    ../../home/keepassxc # key / password manager

    ../../home/tmux # terminal multiplex'er
    ../../home/gaming # some basic gaming packages - steam and so on
    ../../home/greetd # minimalistic greeter, may not be required once fde is used on laptop
    #
    ../../home/kitty # /home/shell/ under mkOption, have foot / kitty / more? in there
    #
    ../../home/kde # TODO rename kdeconnect - maybe not lol - covers lots
    ../../home/ulauncher # TODO rename built theme, add credits to og author
    ../../home/virt # vm / container
    ../../home/waybar
    ../../home/wl-screenrec # testing for laptop - amd / nvidia config
    ../../home/gtk # uhh, nix-colors gtk theme iirc # TODO rename to theme?
    ../../home/prism # wallpapers
    ../../home/syncthing
    ../../home/tailscale # not foss, temp - will replace eventually with netbird / self-hosted
    ../../home/zsh # some basic config for terminal, has modified theme for nix-colors
  ];

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
    hyprpaper.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
    wifi.backend = "nwm";
  };

  services = {
    # map laptop keys
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
      KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
      KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
    '';
  };

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-laptop --show-trace -j 16 && cd ~ && hyprctl reload";
    rebuildboot = "sudo nixos-rebuild --flake ~/nixos#nix-laptop --install-bootloader boot";
    garbage = "sudo nix-collect-garbage && nix-collect-garbage -d";
    s = "kitten ssh";
  };
}
