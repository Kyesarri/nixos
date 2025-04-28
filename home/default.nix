{spaghetti, ...}: {
  # import modules, most with options some are basic / required for all without options
  imports = [
    ./console
    ./freetube
    ./gscreenshot
    ./hypr
    ./lapce
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

    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
