{
  spaghetti,
  inputs,
  pkgs,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/ulauncher.conf" = {
      text = ''
        bind = $mainMod, R, exec, sherlock
      '';
    };

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
          name = "Weather";
          alias = "null";
          tag_start = "null";
          tag_end = "null";
          display_name = "null";
          on_return = "null";
          next_content = "null";
          type = "weather";
          priority = "1.0";
          exit = "true";
          shortcut = "false";
          spawn_focus = "false";
          async = "true";
          args = [
            {
              location = "Albury";
              update_interval = "60";
            }
          ];
          binds = "null";
          actions = [
            {
              name = "show in web";
              exec = "https://www.wttr.in/albury";
              icon = "sherlock-link";
              method = "web_launcher";
              exit = "true";
            }
          ];
          add_actions = "null";
        }
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
