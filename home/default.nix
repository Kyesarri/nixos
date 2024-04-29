{spaghetti, ...}: {
  home-manager.users.${spaghetti.user} = {
    pkgs,
    lib,
    config,
    inputs,
    outputs,
    nix-colors,
    sops-nix,
    ...
  }: {
    colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

    sops = {
      age.keyFile = "/home/${spaghetti.user}/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets/secrets.yaml;

      secrets."github_email" = {
        path = "%r/github_email";
      };
    };

    # import flake home-manager modules here
    imports = [
      inputs.ags.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
      # inputs.agenix.homeManagerModules.age
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
