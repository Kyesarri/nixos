{
  spaghetti,
  secrets,
  pkgs,
  ...
}: let
  statusPort = 22070;
  relayPort = 22067;
in {
  # hyprland binds and window rules
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      # exec-once = sleep 10 && syncthing
      exec-once = sleep 10 && syncthingtray
      windowrule = float, title:Syncthing Tray
      windowrulev2 = size 1000 600, title:Syncthing Tray
    '';
  };

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
    openDefaultPorts = true;
    relay.statusPort = statusPort;
    relay.port = relayPort;
    user = "syncthing";
    group = "syncthing";
    /*
    # TODO
    key = "${</path/to/key.pem>}";
    cert = "${</path/to/cert.pem>}";
    # TODO
    */
    settings = {
      devices = {
        nix-erying = {id = "${secrets.syncthing.id.nix-erying}";};
        p7p = {id = "${secrets.syncthing.id.p7p}";};
        nix-laptop = {id = "${secrets.syncthing.id.nix-laptop}";};
        nix-desktop = {id = "${secrets.syncthing.id.nix-desktop}";};
      };
    };
  };
}
