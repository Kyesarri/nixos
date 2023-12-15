{
  config,
  pkgs,
  ...
}: {
  networking.wireless.iwd.enable = true;

  home-manager.users.kel.home.file.".config/hypr/per-app/wireless.conf" = {
    text = ''
      windowrule = float, ^(org.twosheds.iwgtk)$
      windowrule = float, title:Authentication Required
      windowrule = float, title:Wireless network credentials
    '';
  };
  users.users.kel.packages = with pkgs; [iwd iwgtk];
}
