{pkgs, ...}: {
  users.users.kel.packages = with pkgs; [ulauncher];
  # these are for theme, TODO will be adding support for nix-colors soon :)
  #
  # TODO method for adding exec once = to hyprland config and binding to launch ulauncher, will be a nice-to-have for
  # ulancher and wofi, possibly other applications too
  # end goal is to enable applications in host.nix via import, package enabled, bindings and launch at login will be enabled
  # currently hard-coding each package in hyprland.conf which isn't ideal when multiple programs fill one use-case
  # functionality will be ideal for monitor resolutions on each device too
  imports = [
    ./manifest.json.nix
    ./theme-gtk-3.20.css.nix
    ./theme.css.nix
  ];
}
