{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };

  #home-manager.users.kel.wayland.windowManager.hyprland = {
  #  enable = true;
  #  # ...
  #  plugins = [
  #    inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
  #    # ...
  #  ];
  #};

  #Failed assertions:
  #     - kel profile: Conflicting managed target files: .config/hypr/hyprland.conf
  #
  #     This may happen, for example, if you have a configuration similar to
  #
  #         home.file = {
  #           conflict1 = { source = ./foo.nix; target = "baz"; };
  #           conflict2 = { source = ./bar.nix; target = "baz"; };
  users.users.kel.packages = with pkgs; [hyprpaper];

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];
}
