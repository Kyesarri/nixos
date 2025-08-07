# yoinked from https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
# xoxo love this
{
  inputs,
  pkgs,
  spaghetti,
  ...
}: let
  # used in greetd service
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
  hyprland = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
  username = "${spaghetti.user}";
in {
  services.greetd = {
    enable = true;
    settings = {
      # setup our autologin from boot
      initial_session = {
        command = "${hyprland}";
        user = "${username}";
      };
      # default session after logging out, requires username / password
      default_session = {
        command = "${tuigreet} --time --remember --remember-user-session --sessions ${hyprland-session} --theme 'border=magenta;text=white;prompt=white;time=white;action=blue;button=yellow;container=darkgray;input=white'";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = [pkgs.greetd.tuigreet];

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";

    # without this errors will spam on screen
    StandardError = "journal";

    # without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
