{
  spaghetti,
  pkgs,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    programs.caelestia = {
      enable = true;

      systemd = {
        enable = true;
        target = "hyprland-session.target"; # "graphical-session.target";
        environment = [];
      };

      settings = {
        appearance = {
          anim.duration.scale = 1;
          rounding.scale = 0.5;
          spacing.scale = 1;
          padding = 24; # 12
        };

        border = {
          thickness = 14;
        };

        general = {
          apps = {
            audio = "${pkgs.pavucontrol}/bin/pavucontrol";
            terminal = "${pkgs.kitty}/bin/kitty";
          };
        };

        dashboard = {
          enabled = true;
          showOnHover = true;
          mediaUpdateInterval = 500;
          dragThreshold = 50;
          # weatherLocation = ; waiting to see this is implemented
          sizes = {
            tabIndicatorHeight = 3;
            tabIndicatorSpacing = 5;
            infoWidth = 200;
            infoIconSize = 25;
            dateTimeWidth = 110;
            mediaWidth = 200;
            mediaProgressSweep = 180;
            mediaProgressThickness = 8;
            resourceProgessThickness = 10;
            weatherWidth = 250;
            mediaCoverArtSize = 0; # 150
            mediaVisualiserSize = 0; # 80
            resourceSize = 200;
          };
        };

        bar = {
          sizes = {
            innerWidth = 35;
            windowPreviewSize = 400;
            trayMenuWidth = 300;
            batteryWidth = 250;
            networkWidth = 320;
          };

          clock = {
            showIcon = false;
          };

          entries = [
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "activeWindow";
              enabled = false;
            }
            {
              id = "workspaces";
              enabled = true;
            }
            {
              id = "activeWindow";
              enabled = false;
            }
            {
              id = "tray";
              enabled = true;
            }
            {
              id = "statusIcons";
              enabled = true;
            }
            {
              id = "power";
              enabled = true;
            }
          ];

          workspaces = {
            shown = 6;
            activeIndicator = true;
            activeTrail = true;
            occupiedBg = true;
          };

          status = {
            showAudio = true;
            showBattery = true;
            showMicrophone = false;
            showKbLayout = false;
            showNetwork = true;
            showBluetooth = true;
            showLockStatus = true;
          };

          tray = {
            background = true;
            recolour = true;
          };
        };

        background = {
          enabled = false;
          desktopClock.enabled = false;
          visualiser.enabled = false;
        };

        services = {
          useFahrenheit = false;
          useTwelveHourClock = false;
        };
        paths.wallpaperDir = "~/wallpapers";
      };

      cli = {
        enable = true;
        settings = {
          theme = {
            enableTerm = false;
            enableBtop = false;
            enableGtk = false;
          };
        };
      };
    };
  };
}
