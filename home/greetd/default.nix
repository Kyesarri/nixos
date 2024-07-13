# yoinked from https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
# xoxo love this
# not working anymore with current flake.lock - v0.10? - might be again? requires further testing
{
  inputs,
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  hyprland-session = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions";
in {
  environment.systemPackages = [pkgs.greetd.tuigreet];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --remember-session --sessions ${hyprland-session} --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red";
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
