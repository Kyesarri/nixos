# yoinked from https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
# xoxo love this
# colours set in ./hosts/console.nix - TODO move to own /home/ config, mainly to keep hosts clean
{
  spaghetti,
  inputs,
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red --time --remember --remember-session --sessions ${hyprland-session}";
        # user = "${spaghetti.user}";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
