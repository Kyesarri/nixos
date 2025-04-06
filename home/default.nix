{spaghetti, ...}: {
  # import modules, most with options some are basic / required for all without options
  imports = [
    ./console
    ./freetube
    ./gscreenshot
    ./hypr
    ./nebula
    ./nemo
  ];

  # home-manager config(s)
  home-manager.users.${spaghetti.user} = {inputs, ...}: {
    # import flake home-manager modules
    imports = [
      inputs.nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
      inputs.schizofox.homeManagerModules.default
    ];

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

    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
