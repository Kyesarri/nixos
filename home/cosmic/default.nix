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
}
