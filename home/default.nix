{
  spaghetti,
  inputs,
  ...
}: {
  # import modules, most with options some are basic / required for all without options
  imports = [
    ./caelestia-shell
    ./clipse
    ./console
    ./freetube
    ./gscreenshot
    ./hypr
    ./lapce
    ./nebula
    ./nemo
    ./neovim
  ];

  # home-manager.extraSpecialArgs = {inherit inputs;};

  # home-manager config(s)
  home-manager.users.${spaghetti.user} = {inputs, ...}: {
    # import flake home-manager modules
    imports = [
      inputs.caelestia-shell.homeManagerModules.default
      inputs.nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
    ];

    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
