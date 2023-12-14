{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      exec-once = sleep 3 && syncthingtray
    '';
  };

  services = {
    syncthing = {
      enable = true;
      user = "kel";
    };
  };

  users.users.kel.packages = with pkgs; [
    syncthing
    syncthingtray
  ];
}
