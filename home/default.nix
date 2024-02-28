{spaghetti, ...}: {
  home-manager.users.${spaghetti.user} = {
    pkgs,
    lib,
    config,
    inputs,
    outputs,
    nix-colors,
    ...
  }: {
    imports = [
      inputs.ags.homeManagerModules.default # imports from flake.nix, is this needed in /hosts/laptop/default.nix anymore?
      inputs.nix-colors.homeManagerModules.default
    ];
    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
