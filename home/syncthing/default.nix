{
  spaghetti,
  secrets,
  pkgs,
  lib,
  ...
}: let
  statusPort = 22070;
  relayPort = 22067;
in {
  # hyprland binds and window rules
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      exec-once = sleep 10 && syncthingtray
      windowrule = float, title:Syncthing Tray
      windowrulev2 = size 1000 600, title:Syncthing Tray
    '';
  };

  # create directory in /etc and change owner and group
  system.activationScripts."makeSyncthingDir" =
    lib.stringAfter ["var"]
    ''mkdir -v -p /etc/syncthing & chown -R 1000:syncthing /etc/syncthing'';

  # add our user to the same group as syncthing user
  users.groups.syncthing = {
    name = "syncthing";
    members = ["syncthing" "${spaghetti.user}"];
  };

  # open ports for syncthing
  networking.firewall.allowedTCPPorts = [statusPort relayPort];

  # add tray icon package
  users.users.${spaghetti.user}.packages = with pkgs; [syncthingtray];

  # don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  # syncthing service config
  services.syncthing = {
    enable = true;
    systemService = true;
    overrideDevices = false; # keep manually added devices
    openDefaultPorts = true;
    dataDir = "/etc/syncthing"; # use the dir we created above in activation script
    relay.statusPort = statusPort;
    relay.port = relayPort;
    user = "${spaghetti.user}"; # run under our user
    group = "syncthing";
    settings = {
      devices = {
        nix-erying = {id = "${secrets.syncthing.id.nix-erying}";};
        p7p = {id = "${secrets.syncthing.id.p7p}";};
        nix-laptop = {id = "${secrets.syncthing.id.nix-laptop}";};
        nix-desktop = {id = "${secrets.syncthing.id.nix-desktop}";};
      };
      folders = {
        kpass = {
          enable = true;
          devices = ["nix-laptop" "nix-desktop" "nix-erying" "p7p"];
          path = "/etc/syncthing/kpass";
          type = "sendreceive";
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
    };
  };
}
