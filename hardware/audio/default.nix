{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.home.file.".config/hypr/per-app/audio.conf" = {
    text = ''
      windowrule = float, ^(pavucontrol)$
    '';
  };
  users = {
    users.kel.packages = with pkgs; [
      pamixer # cli pulse audio mixer
      pavucontrol # audio control gui
    ];
  };
}
