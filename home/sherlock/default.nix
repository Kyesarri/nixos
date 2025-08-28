{
  spaghetti,
  inputs,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    programs.sherlock = {
      enable = true;

      # to run sherlock as a daemon
      systemd.enable = true;

      # If wanted, you can use this line for the _latest_ package. / Otherwise, you're relying on nixpkgs to update it frequently enough.
      # For this to work, make sure to add sherlock as a flake input!
      package = inputs.sherlock.packages.${pkgs.system}.default;

      # config.toml
      settings = {};

      # sherlock_alias.json
      aliases = {
        vesktop = {name = "Discord";};
      };

      # sherlockignore
      ignore = ''
        Avahi*
      '';

      # fallback.json
      launchers = [
        {
          name = "Calculator";
          type = "calculation";
          args = {
            capabilities = [
              "calc.math"
              "calc.units"
            ];
          };
          priority = 1;
        }
        {
          name = "App Launcher";
          type = "app_launcher";
          args = {};
          priority = 2;
          home = "Home";
        }
      ];

      # main.css
      style =
        /*
        css
        */
        ''
          * {
            font-family: sans-serif;
          }
        '';
    };
  };
}
