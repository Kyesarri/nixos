{
  pkgs,
  inputs,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./per-device.nix # hyprland per-device config
    ./hardware.nix # machine hardware
    ./boot.nix # per device boot config

    ../standard.nix

    ../../hardware # not all hardware modules are required to be imported
    ../../hardware/audio
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/nvidia

    ../../home # set some default values for home-manager

    ../../home/cosmic
    ../../home/asusctl # TODO look into issues with this further
    ../../home/bottom # task-manager
    ../../home/codium # TODO build custom theme to use, with nix-colors. # TODO pin versions to avoid compiling
    ../../home/copyq # TODO change to an alternative maybe?
    ../../home/dunst # ags has own notification daemon, will require fixing brightness scripts
    ../../home/firefox # why you always need to build from source, check to see if there are nighty / beta precompiled
    ../../home/git
    ../../home/keepassxc

    ../../home/tmux
    ../../home/gaming
    ../../home/greetd
    #
    ../../home/kitty # /home/shell/ under mkOption, have foot / kitty / more? in there
    #
    ../../home/kde # TODO rename kdeconnect - maybe not lol - covers lots
    ../../home/ulauncher # TODO rename built theme, add credits to og author
    ../../home/virt # vm / container
    ../../home/vpn
    ../../home/wl-screenrec # testing for laptop - amd / nvidia config
    ../../home/gtk # uhh, nix-colors gtk theme iirc # TODO rename to theme?
    ../../home/prism # wallpapers
    ../../home/tailscale
    ../../home/zsh
  ];

  networking.hostName = "nix-laptop";

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
    hyprpaper.enable = true;
    ags.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
    wifi.backend = "nwm";
  };

  programs.corectrl.enable = true;

  services = {
    xserver.enable = false;
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
      KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
      KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      pciutils
      tailscale
    ];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-laptop --show-trace -j 16 && cd ~ && hyprctl reload && ./ags.sh";
    shellAliases.rebuildboot = "sudo nixos-rebuild --flake /home/${spaghetti.user}/nixos#nix-laptop --install-bootloader boot";
    shellAliases.garbage = "sudo nix-collect-garbage && nix-collect-garbage -d";
    shellAliases.s = "kitten ssh";
  };
}
