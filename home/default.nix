{spaghetti, ...}: {
  # testing importing new modules with configs
  # not importing via home-manager as these call home-manager
  # as a module and are not themselves home-manager-modules 🍝

  imports = [
    ./freetube
    ./gscreenshot
    ./hypr
    ./nebula
    ./nemo
    ./vula
  ];

  home-manager.users.${spaghetti.user} = {
    inputs,
    pkgs,
    lib,
    ...
  }: {
    # this shit is painful, there looks to be heaps of work here
    # to get an easy theme changing script working via home-manager
    # seems like my implementation of nix-colors is whack
    # or that using home-manager as a module rather than
    # a standalone package has made this quite a difficult task
    # to accomplish.

    # my modules are a combination of home-manager configs along with standard nix configs.
    # i could look into having configs for programs (activating them) and
    # for home manager, then have the home-manager.nix / host.nix import seperate to eachother
    # that too feels messy, and that there should be a better method for deploying things

    # will spend more time on this when time permits - my main issue
    # currently with my configs / nix-colors is that
    # i have declared my colour scheme in my nix config
    # setting nix-colors scheme in home-manager seems to do
    # nothing at all, unless I'm overlooking something :D
    # to add - i cannot seem to set the colour scheme
    # only in home-manager as my config complains about
    # missing args (colorscheme) not being set

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

    specialisation.light-theme.configuration = {
      # We have to force the values below to override the ones defined above
      colorScheme = lib.mkForce {
        slug = "catppuccinLatte";
        palette = {
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

    # import flake home-manager modules
    imports = [
      inputs.nix-colors.homeManagerModules.default
      inputs.prism.homeModules.prism
      inputs.hyprland.homeManagerModules.default
    ];

    programs.home-manager.enable = true; # enable home-manager
    xdg.enable = true;
    home.username = "${spaghetti.user}";
    home.homeDirectory = "/home/${spaghetti.user}";
    home.stateVersion = "23.11";
  };
}
