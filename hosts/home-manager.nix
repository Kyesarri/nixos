{spaghetti, ...}: {
  home-manager.users.${spaghetti.user} = {
    nix-colors,
    inputs,
    pkgs,
    lib,
    ...
  }: {
    # import flake home-manager modules
    imports = [
      inputs.ags.homeManagerModules.default
      nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
    ];

    programs.home-manager.enable = true; # enable home-manager
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11"; # don't changeme

    colorscheme = {
      slug = "horizon-dark";
      colors = {
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

    specialisation.light-theme.configuration = {
      # We have to force the values below to override the ones defined above
      colorScheme = lib.mkForce {
        slug = "catppuccinLatte";
        colors = {
          base00 = "#eff1f5";
          base01 = "#e6e9ef";
          base02 = "#ccd0da";
          base03 = "#bcc0cc";
          base04 = "#acb0be";
          base05 = "#4c4f69";
          base06 = "#dc8a78";
          base07 = "#7287fd";
          base08 = "#d20f39";
          base09 = "#fe640b";
          base0A = "#df8e1d";
          base0B = "#40a02b";
          base0C = "#179299";
          base0D = "#1e66f5";
          base0E = "#8839ef";
          base0F = "#dd7878";
        };
      };

      home.packages = with pkgs; [
        # note the hiPrio which makes this script more important then others and is usually used in nix to resolve name conflicts
        (hiPrio (writeShellApplication {
          name = "toggle-theme";
          runtimeInputs = with pkgs; [home-manager coreutils ripgrep];
          # the interesting part about the script below is that we go back two generations
          # since every time we invoke a activation script home-manager creates a new generation
          text = ''
            "$(home-manager generations | head -2 | tail -1 | rg -o '/[^ ]*')"/activate
          '';
        }))
      ];
    };

    home.packages = with pkgs; [
      (writeShellApplication {
        name = "toggle-theme";
        runtimeInputs = with pkgs; [home-manager coreutils ripgrep];
        text = ''
          "$(home-manager generations | head -1 | rg -o '/[^ ]*')"/specialisation/light-theme/activate
        '';
      })
    ];
  };
}
