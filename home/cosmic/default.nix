{
  spaghetti,
  pkgs,
  ...
}: {
  users.users.${spaghetti.user}.packages = with pkgs; [
    cosmic-tasks
    cosmic-icons
    cosmic-files
    cosmic-settings
    cosmic-screenshot
    cosmic-edit
    cosmic-panel
    cosmic-osd
  ];
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/cosmictasks.conf" = {
    text = ''
      # launch cosmic tasks meta + t
      bind = $mainMod, T, exec, tasks
    '';
  };
}
