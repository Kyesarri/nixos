{
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  imports = [./console.nix]; # console colours
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  security = {
    pam.services.gdm.enableGnomeKeyring = true; # unlock keyring with gdm / gdm support for keyring

    # device is always on, don't want to hibernate
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
              action.id == "org.freedesktop.login1.hibernate" ||
              action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
          {
              return polkit.Result.NO;
          }
      });
    '';
  };

  nix = {
    sshServe.enable = true; # enable ssh server
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true; # auto nix garbage collection
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    settings = {
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d iirc
      experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
    };
  };

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  fonts = {
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
    fontDir.enable = true;
    packages = with pkgs; [hack-font];
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.${spaghetti.user} = {
    shell = pkgs.zsh; # set our shell pkg
    isNormalUser = true; # not true
    description = "${spaghetti.user}";
    extraGroups = [
      "networkmanager" # control network interfaces
      "wheel" # enables sudo for user
      "apex" # google coral
      "media" # arr services
      "podman" # controlling pods
      "dialout" # serial interfaces
    ];
    packages = with pkgs; [
      fet-sh # minimal fetch script
      gnome.seahorse # key management
      libnotify # notifications might not be needed on headless lol
      udiskie # usb mounting, probs for the best atm
    ];
  };
}
