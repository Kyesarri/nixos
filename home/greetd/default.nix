# yoinked from https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
# xoxo love this
{
  inputs,
  pkgs,
  spaghetti,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
  hyprland = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
  username = "${spaghetti.user}";
in {
  environment.systemPackages = [pkgs.greetd.tuigreet];

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${hyprland}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --time --remember --remember-user-session --sessions ${hyprland-session} --theme 'border=magenta;text=white;prompt=white;time=white;action=blue;button=yellow;container=darkgray;input=white'";
        user = "greeter";
      };
    };
  };

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
