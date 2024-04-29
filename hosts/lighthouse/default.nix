{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  spaghetti,
  sops-nix,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./hardware.nix # device specific hardware config

    ../headless.nix # base packages and config, may need to move some of those values to this config

    ../../home # home-manaager config for all machines currently
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/git # some baseline git config in there
    ../../home/kitty # yes pls
    ../../home/gtk # has some theming bits, might have some requirement still
    ../../home/zsh # yes pls
  ];

  /*
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${spaghetti.user}/.config/sops/age/keys.txt";
    secrets = {
      "network/gateway" = {};
    };
  };
  */

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  users.users.${spaghetti.user} = {
    uid = 1000;
    openssh.authorizedKeys.keys = [
      # pub key
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlAcSSKVfxng7E1w0XAwS5KHn1ScZLEyTJItGpVr08kqTpa8FMomb5raQ85kGfj9HiwdkziMzOEUU9GRaJ09SCjFFfkkyQ7TK9g4kxXnl10CVUjYGN/+y/qYitiL5RiK6z4LAHpw4uGCNZjFIxjnjsCx2L5Iehg6Fhca5vkaDtG8l7jF1FED+jLLHZucODSzN+K5qRFU5J3guXeD5Fl9dw24N2KWYldJmMXZNpUwfcNoqHuEgp0ehq0RLtMzquHJ+AfymBnCd1YVbMhft3Vk2vwJ6X7gkwkcI2og3QQCZv8ohBUAChG75C+zlXy4Zj69QrtakfyfIG6vVNIu+72k1z ssh-key-2024-04-28''
    ];
  };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      # pub key
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlAcSSKVfxng7E1w0XAwS5KHn1ScZLEyTJItGpVr08kqTpa8FMomb5raQ85kGfj9HiwdkziMzOEUU9GRaJ09SCjFFfkkyQ7TK9g4kxXnl10CVUjYGN/+y/qYitiL5RiK6z4LAHpw4uGCNZjFIxjnjsCx2L5Iehg6Fhca5vkaDtG8l7jF1FED+jLLHZucODSzN+K5qRFU5J3guXeD5Fl9dw24N2KWYldJmMXZNpUwfcNoqHuEgp0ehq0RLtMzquHJ+AfymBnCd1YVbMhft3Vk2vwJ6X7gkwkcI2og3QQCZv8ohBUAChG75C+zlXy4Zj69QrtakfyfIG6vVNIu+72k1z ssh-key-2024-04-28''
    ];
  };

  services = {
    openssh.enable = true;
    xserver.enable = false; # headless
    printing.enable = false; # cpus printers

    dbus.enable = true;
  };

  hardware = {};

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "nix-lighthouse";
  networking.domain = "";
  services.openssh.enable = true;

  environment = {
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-lighthouse --show-trace";

    shells = with pkgs; [zsh]; # default shell to zsh
    systemPackages = with pkgs; [
      busybox
      curl
      wget
      libsecret
      gitAndTools.gitFull
      age
    ];
  };
}
