{spaghetti, ...}: {
  # testing importing new modules with configs
  # not importing via home-manager as these call home-manager
  # as a module and are not themselves home-manager-modules 🍝
  imports = [
    ./ags
    ./freetube
    ./gscreenshot
    ./hypr
    ./nemo
  ];
  home-manager.users.${spaghetti.user} = {inputs, ...}: {
    colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

    # import flake home-manager modules here
    imports = [
      inputs.ags.homeManagerModules.default
      inputs.nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
    ];
    programs.home-manager.enable = true; # home manager enables itself, freaky tequila magic
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
