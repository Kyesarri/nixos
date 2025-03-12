{
  spaghetti,
  config,
  ...
}: {
  imports = [
    ./freetube
    ./gscreenshot
    ./hypr
    ./nebula
    ./nemo
  ];

  # set our console theme to match nix-colors
  console = {
    earlySetup = true;
    useXkbConfig = true; # same config for linux console
    colors = [
      # terminal8
      "${config.colorScheme.palette.base00}" # black
      "${config.colorScheme.palette.base08}" # red
      "${config.colorScheme.palette.base0B}" # green
      "${config.colorScheme.palette.base0A}" # yellow
      "${config.colorScheme.palette.base0D}" # blue
      "${config.colorScheme.palette.base0E}" # magenta
      "${config.colorScheme.palette.base0C}" # cyan
      "${config.colorScheme.palette.base05}" # white
      # terminal16
      "${config.colorScheme.palette.base03}" # bright black
      "${config.colorScheme.palette.base09}" # bright red
      "${config.colorScheme.palette.base0B}" # bright green
      "${config.colorScheme.palette.base0A}" # bright yellow
      "${config.colorScheme.palette.base0D}" # bright blue
      "${config.colorScheme.palette.base0E}" # bright magenta
      "${config.colorScheme.palette.base0C}" # bright cyan
      "${config.colorScheme.palette.base07}" # bright white
    ];
  };

  # home-manager config(s)
  home-manager.users.${spaghetti.user} = {inputs, ...}: {
    colorscheme = {
      slug = "horizon-dark";
      palette = {
        base00 = "1C1E26";
        base01 = "232530";
        base02 = "2E303E";
        base03 = "6F6F70";
        base04 = "9DA0A2";
        base05 = "CBCED0";
        base06 = "DCDFE4";
        base07 = "E3E6EE";
        base08 = "E93C58";
        base09 = "E58D7D";
        base0A = "EFB993";
        base0B = "EFAF8E";
        base0C = "24A8B4";
        base0D = "DF5273";
        base0E = "B072D1";
        base0F = "E4A382";
      };
    };

    # import flake home-manager modules
    imports = [
      inputs.nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
      inputs.schizofox.homeManagerModules.default
    ];

    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
