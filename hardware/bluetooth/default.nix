{
  config,
  pkgs,
  ...
}: {
  hardware.bluetooth.enable = true;

  home-manager.users.kel.home.file.".config/hypr/per-app/bluetooth.conf" = {
    text = ''
      windowrule = float, ^(blueberry.py)$
    '';
  };
  users.users.kel.packages = with pkgs; [blueberry];
}
