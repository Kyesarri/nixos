{
  spaghetti,
  inputs,
  pkgs,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/ulauncher.conf" = {
      text = ''bind = $mainMod, R, exec, sherlock'';
    };

    programs.sherlock = {
      enable = true;

      # to run sherlock as a daemon
      systemd.enable = true;

      package = inputs.sherlock.packages.${pkgs.system}.default;

      # inspo taken from https://github.com/khaneliman/khanelinix/blob/c36a1e77374fe3776c23a2e30758725e18cf63d7/modules/home/programs/graphical/launchers/sherlock/default.nix
      # config.toml
      settings = {
        behavior = {
          use_xdg_data_dir_icons = false; # causes slowdown :(
          animate = true; # temp disabled in source?
        };

        default_apps = {
          browser = "librewolf";
          terminal = "kitty";
        };

        expand = {
          enable = true; # anchors to top of screen
          edge = "top"; # does not use this / option of top only exists?
          margin = 150; # ehh might be able to push this to the middle'ish of the screen using this
        };

        caching = {
          enable = true;
        };

        units = {
          lengths = "meter";
          weights = "kg";
          volumes = "l";
          temperatures = "C";
          currency = "aud";
        };

        appearance = {
          width = 800;
          height = 600;
          gsk_renderer = "cairo"; # vulkan caused artifacts on text :(
          icon_size = 30;
          use_system_theme = true;
          search_icon = false;
          opacity = 1;
          num_shortcuts = 0; # expand ignores this?
        };

        backdrop = {
          enable = false;
          opacity = 0.3;
          edge = "top";
        };

        runtime = {
          center = true;
        };

        status_bar = {
          enable = true;
        };

        search_bar_icon = {
          enable = false;
          icon = "system-search-symbolic";
          icon_back = "go-previous-symbolic";
          size = 30;
        };
      };

      # sherlock_alias.json
      aliases = {};

      # sherlockignore
      ignore = ''
        Avahi*
      '';

      # fallback.json
      launchers = [
        {
          name = "Weather";
          type = "weather";
          args = {
            location = "Albury";
            update_interval = 60;
          };
          priority = 1;
          home = "Home";
          async = true;
          shortcut = false;
          spawn_focus = false;
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
          alias = "app";
          type = "app_launcher";
          args = {};
          priority = 2;
          home = "Home";
        }
        {
          name = "NixOS Package Search";
          display_name = "NixOS Package Search";
          alias = "pkg";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          type = "web_launcher";
          priority = 3;
          args = {
            search_engine = "https://search.nixos.org/packages?channel=unstable&query={keyword}";
            icon = "nix-snowflake";
          };
        }
        {
          name = "NixOS Options Search";
          display_name = "NixOS Options Search";
          alias = "opt";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          type = "web_launcher";
          priority = 4;
          args = {
            search_engine = "https://search.nixos.org/options?channel=unstable&query={keyword}";
            icon = "nix-snowflake";
          };
        }
        {
          name = "NixOS Wiki Search";
          display_name = "NixOS Wiki Search";
          alias = "wik";
          tag_start = "{keyword}";
          tag_end = "{keyword}";
          type = "web_launcher";
          priority = 5;
          args = {
            search_engine = "https://wiki.nixos.org/w/index.php?search={keyword}";
            icon = "nix-snowflake";
          };
        }
        /*
          #TODO configure nix-search-tv and television
          "TV" = {
            icon = "nix-snowflake";
            exec = "kitty -e nix-search-tv";
            search_string = "interactive;search;tv";
          };
        };
        */
      ];

      # main.css
      style = ''
        :root {
            --background: #1C1E26;
            --foreground: #232530;
            --text: #CBCED0;
            --border: #B072D1;

            --shadow: #FFFFFF;


            --tag-background: #2E303E;
            --tag-color: hsl(220, 10%, 100%);
            --error: hsl(4, 71%, 62%);
            --warning: hsl(55, 100%, 68%);
            --success: hsl(140, 40%, 40%);

            --weather-clear: linear-gradient(45deg, #24A8B4 0%, #DCDFE4 50%);
            --weather-few-clouds: linear-gradient(45deg, #A1A1A1 0%, #87B2E0 100%);
            --weather-many-clouds: linear-gradient(45deg, #B2B2B2 0%, #C8C8C8 100%);
            --weather-mist: linear-gradient(45deg, #878787 0%, #D1D1C7 100%);
            --weather-showers: linear-gradient(45deg, #73848C 0%, #374B54 100%);
            --weather-freezing-scattered-rain-storm: linear-gradient(45deg, #1A1C1F 0%, #242B35 100%);
            --weather-freezing-scattered-rain: linear-gradient(45deg, #73848C 0%, #242B35 100%);
            --weather-snow-scattered-day: linear-gradient(45deg, #73848C 0%, #242B35 100%);
            --weather-storm: linear-gradient(45deg, #1A1C1F 0%, #242B35 100%);
            --weather-snow-storm: linear-gradient(45deg, #1A1C1F 0%, #242B35 100%);
            --weather-snow-scattered-storm: linear-gradient(45deg, #1A1C1F 0%, #242B35 100%);
            --weather-showers-scattered: linear-gradient(45deg, #73848C 0%, #374B54 100%);

            --weather-none-available: hsl(0, 0%, 50%);
            /* Neutral placeholder gray */
        }

        /*
        --warning: #E58D7D;
        --error: #DF5273;
        --success: #24A8B4;
        */


        overshoot *,
        undershoot *,
        overshoot.top,
        overshoot.right,
        overshoot.bottom,
        overshoot.left undershoot.top,
        undershoot.right,
        undershoot.bottom,
        undershoot.left,
        .scroll-window>*,
        overshoot:backdrop {
            background: none;
            border: none;
            background-color: transparent;
        }

        * {
            all: unset;
            padding: 0px;
            margin: 0px;
            -gtk-secondary-caret-color: var(--background);
            outline-width: 0px;
            outline-offset: -3px;
            outline-style: dashed;
            line-height: 1;
            font-family: "Hack-Regular";
        }

        label {
            color: var(--text);
        }


        #overlay spinner {
            color: var(--text);
        }

        row:selected,
        #overlay * {
            background: transparent;
        }

        .notifications {
            background: transparent;
        }

        scrolledwindow>viewport,
        scrolledwindow>viewport>*,
        listview,
        gridview,
        window {
            background: var(--background);
        }

        #backdrop {
            background: black;
        }




        window:not(#backdrop) {
            color: var(--text);
            border-radius: 5px;
            border: 2px solid var(--border);
        }



        /* SEARCH PAGE */
        #search-bar {
            outline: none;
            border: none;
            background: hsl(from var(--background) h s l / 100%);
            min-height: 40px;
            color: var(--text);
            font-size: 15px;
            padding-left: 20px;
        }

        #search-bar-holder {
            border-bottom: 2px solid var(--border);
            padding: 5px 10px 4px 10px;
        }

        #search-icon-holder image {
            transition: 0.1s ease;
        }

        #search-icon-holder.search image:nth-child(1) {
            transition-delay: 0.05s;
            opacity: 1;
        }

        #search-icon-holder.search image:nth-child(2) {
            transform: rotate(-180deg);
            opacity: 0;
        }

        #search-icon-holder.back image:nth-child(1) {
            opacity: 0;
        }

        #search-icon-holder.back image:nth-child(2) {
            transition-delay: 0.05s;
            opacity: 1;
        }


        #search-icon {
            margin-left: 10px;
        }

        #search-bar:focus {
            outline: none;
        }

        #search-bar placeholder {
            background: transparent;
            background-color: transparent;
            color: hsl(from var(--text) h s l / 70%);
            font-weight: 500;
        }

        #category-type {
            font-size: 13px;
            font-weight: bold;
            color: var(--text);
            opacity: 0.3;
            padding: 10px 20px 0px 20px;
        }

        .scrolled-window {
            padding: 10px 10px 5px 10px;
            min-width: var(--width) * 0.8;
        }

        scrollbar {
            transform: translate(8px, 0px);
            border: none;
            background: none;
        }

        scrollbar slider {
            background: hsl(from var(--text) h s l / 10%);
            border: none;
        }


        image {
            color: white;
        }

        .tile {
            outline: none;
            min-height: 50px;
            padding: 0px 10px;
            margin-bottom: 5px;
            border: 1px solid transparent;
            border-radius: 4px;
        }

        .tile:hover *,
        .tile:hover {
            background: transparent;
        }

        .tile.animate {
            transform: translateY(20px);
            opacity: 0;
            animation: fadeInUp 0.2s ease-out forwards;
        }

        row:nth-child(1) .tile.animate {
            animation-delay: 0.05s;
        }

        row:nth-child(2) .tile.animate {
            animation-delay: 0.1s;
        }


        row:nth-child(3) .tile.animate {
            animation-delay: 0.15s;
        }

        row:nth-child(4) .tile.animate {
            animation-delay: 0.2s;
        }

        row:nth-child(5) .tile.animate {
            animation-delay: 0.25s;
        }

        row:nth-child(6) .tile.animate {
            animation-delay: 0.3s;
        }

        row:nth-child(7) .tile.animate {
            animation-delay: 0.35s;
        }

        row:nth-child(8) .tile.animate {
            animation-delay: 0.4s;
        }

        row:nth-child(9) .tile.animate {
            animation-delay: 0.45s;
        }

        row:nth-child(10) .tile.animate {
            animation-delay: 0.5s;
        }

        @keyframes fadeInUp {
            from {
                letter-spacing: 1px;
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                letter-spacing: 0px;
                opacity: 1;
                transform: translate(0px);
            }
        }

        .tile #title {
            font-size: 15px;
            color: var(--text);
        }

        .tile #icon {
            margin: 0px;
            padding: 0px;
        }

        row:selected .tile {
            background: hsl(from var(--foreground) h s l / 100%);
            background-color: hsl(from var(--foreground) h s l / 100%);
        }

        row:selected .tile.multi-active,
        .tile.multi-active {
            background: hsl(from var(--foreground) h s l / 100%);
            background-color: hsl(from var(--foreground) h s l / 100%);
            border: 1px solid hsl(from var(--text) h s l / 20%);
        }

        .tile:selected .tag,
        .tag {
            font-size: 11px;
            border-radius: 3px;
            padding: 2px 8px;
            color: var(--tag-color);
            box-shadow: 0px 0px 10px 0px rgba(2, 2, 2, 0.4);
            border: 1px solid hsl(from var(--text) h s l / 10%);
            margin-left: 7px;
        }

        .tile:selected .tag-start,
        .tag-start {
            background: hsl(from var(--tag-background) h s l / 70%);
        }

        .tile:selected .tag-end,
        .tag-end {
            background: hsl(from var(--success) h s l / 100);
        }

        .tile:focus {
            outline: none;
        }

        #launcher-type {
            font-size: 10px;
            color: hsl(from var(--text) h s l / 40%);
            margin-left: 0px;
        }

        #color-icon-holder {
            border-radius: 50px;
        }


        /*SHORTCUT*/
        #shortcut-holder {
            margin-right: 25px;
            padding: 5px 10px;
            background: hsl(from var(--foreground) h s l / 50%);
            border-radius: 5px;
            border: 1px solid hsl(from var(--text) h s l / 10%);
            box-shadow: 0px 0px 6px 0px rgba(15, 15, 15, 1);
        }

        .tile:selected #shortcut-holder {
            background: hsl(from var(--background) h s l / 50%);
            background-color: hsl(from var(--background) h s l / 50%);
            color: hsl(from var(--text) h s l / 50%);
            box-shadow: 0px 0px 6px 0px rgba(22, 22, 22, 1);
        }

        #shortcut,
        #shortcut-modkey {
            background: hsl(from var(--background) h s l / 0%);
            background-color: hsl(from var(--background) h s l / 0%);
            font-size: 11px;
            font-weight: bold;
            color: hsl(from var(--text) h s l / 50%);
        }

        #shortcut-modkey {
            font-size: 13px;
        }


        /*CALCULATOR*/
        .calc-tile {
            padding: 10px 10px 20px 10px;
            border-radius: 5px;
        }

        #calc-tile-quation {
            font-size: 10px;
            color: gray;
        }

        #calc-tile-result {
            font-size: 25px;
            color: gray;
        }

        /*EVENT TILE*/
        .tile.tile.event-tile {
            padding: 5px 10px;
        }

        .tile.event-tile #title-label {
            padding: 2px 0px 7px 5px;
            text-transform: capitalize;
        }

        .tile.event-tile #time-label {
            font-size: 3rem;
        }

        #end-time-label {
            color: gray;
        }




        /* BULK TEXT TILE */
        .bulk-text {
            padding-bottom: 10px;
            min-height: 50px;
        }


        #bulk-text-title {
            margin-left: 10px;
            padding: 10px 0px;
            font-size: 10px;
            color: gray;
        }

        #bulk-text-content-title {
            font-size: 17px;
            font-weight: bold;
            color: var(--text);
            min-height: 20px;
        }

        #bulk-text-content-body {
            font-size: 14px;
            color: var(--text);
            line-height: 1.4;
            min-height: 20px;
        }



        /* MPRIS TILE*/
        #mpris-icon-holder {
            border-radius: 5px;
        }

        /*Animation for replacing album covers*/
        .image-replace-overlay #album-cover {
            opacity: 1;
            animation: ease-opacity 0.5s forwards;
        }

        /* EMOJI */
        gridview child {
            padding: 5px;
            background: transparent;
        }

        gridview child box {
            background: var(--foreground);
            border-radius: 5px;
            border: 1px solid transparent;
        }

        gridview child:selected box {
            border: 1px solid var(--tag-color);
        }


        /* NEXT PAGE */
        .next_tile {
            color: var(--text);
            background: var(--background);
        }

        .next_tile #content-body {
            background: var(--background);
            padding: 10px;
            color: var(--text);
        }

        .raw_text,
        .next_tile #content-body {
            font-family: 'Fira Code', monospace;
            font-feature-settings: "kern" off;
            font-kerning: None;
        }


        /*Error*/
        .error-tile #scroll-window {
            padding: 10px;
            min-height: 50px;
        }

        .error-tile {
            border-radius: 4px;
            padding: 5px 10px 10px 10px;
            color: white;
            border: 1px solid transparent;
            margin-bottom: 10px;
        }

        .error-tile * {
            background: transparent;
        }

        .error {
            border: 1px solid hsl(from var(--error) h s l / 50%);
            background: hsl(from var(--error) h s l / 10%);
        }

        .warning {
            border: 1px solid hsl(from var(--warning) h s l / 50%);
            background: hsl(from var(--warning) h s l / 10%);
        }

        .error-tile #title {
            padding: 10px;
            font-size: 10px;
            color: gray;
        }

        .error-tile #content-title {
            margin-left: 10px;
            font-size: 16px;
            font-weight: bold;
            color: var(--text);
        }

        .error-tile #content-body {
            margin-left: 10px;
            font-size: 14px;
            color: var(--text);
            line-height: 1.4;
            color: gray;
        }

        /* STATUS BAR */
        .status-bar {
            background: hsl(from var(--foreground) h s l / 20%);
            border-top: 1px solid var(--border);
            padding: 4px 10px 4px 20px;
        }

        .status-bar label {
            color: hsl(from var(--text) h s l / 30%);
        }

        .status-bar #shortcut-key,
        .status-bar #shortcut-modifier {
            background: var(--foreground);
            margin: 2px;
            padding: 1px 5px;
            border-radius: 3px;
            font-size: 13px;
        }

        .status-bar #shortcut-description {
            font-size: 13px;
            margin-right: 10px;
        }

        .spinner-disappear {
            animation: vanish-rotate 0.3s ease forwards;
        }

        .spinner-appear {
            animation: ease-opacity 0.3s ease forwards;
            animation: rotate 0.3s linear infinite;
        }

        .inactive {
            opacity: 0;
            transition: 0.1s ease;
        }

        .active {
            opacity: 1;
            transition: 0.1s ease;
        }

        /* CONTEXT MENU */
        #context-menu {
            min-width: 50px;
            padding: 5px;
            margin: 4px;
            background: var(--background);
            border: 1px solid var(--border);
            border-radius: 5px;
            box-shadow: unset;
        }

        #context-menu row {
            color: hsl(from var(--text) h s l / 80%);
            transition: 0.1s ease;
            padding: 10px 20px;
            border-radius: 5px;
        }

        #context-menu label {
            color: hsl(from var(--text) h s l / 80%);
            font-size: 13px;
        }

        #context-menu row:selected {
            background: var(--foreground);
        }


        /* WEATHER TILE */
        .weather-tile {
            padding: 0px 20px 0px 10px;
            background: darkgray;
            /* margin-bottom: 10px; */
        }

        .tile.weather-tile #content-holder {
            opacity: 0;
        }

        .tile.weather-tile.weather-animate #content-holder {
            animation: ease-opacity 0.3s forwards;
            transition: background 0.3s ease;
            opacity: 1;
        }

        .tile.weather-tile.weather-no-animate #content-holder {
            opacity: 1;
        }

        .tile.weather-tile #location {
            margin-left: 5px;
            padding: 10px 0px;
            font-size: 10px;
        }

        .tile.weather-tile #temperature {
            font-size: 30px;
        }

        .tile.weather-tile #content-holder {
            margin-bottom: 15px;
        }



        /*WEATHER CLASSES*/
        /* Weather Types */
        .tile.weather-tile.weather-clear {
            background: var(--weather-clear);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-few-clouds {
            background: var(--weather-few-clouds);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-many-clouds {
            background: var(--weather-many-clouds);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-mist {
            background: var(--weather-mist);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-showers {
            background: var(--weather-showers);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-freezing-scattered-rain-storm {
            background: var(--weather-freezing-scattered-rain-storm);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-freezing-scattered-rain {
            background: var(--weather-freezing-scattered-rain);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-snow-scattered-day {
            background: var(--weather-snow-scattered-day);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-storm {
            background: var(--weather-storm);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-snow-storm {
            background: var(--weather-snow-storm);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-snow-scattered-storm {
            background: var(--weather-snow-scattered-storm);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-showers-scattered {
            background: var(--weather-showers-scattered);
            background-clip: padding-box;
        }

        .tile.weather-tile.weather-none-available {
            background: var(--weather-none-available);
            background-clip: padding-box;
        }

        /* TIMER TILE */
        .tile.timer-tile {
            padding: 10px 10px 10px 15px;
            background: transparent;
        }


        .tile.timer-tile.normal #timer-count {
            font-size: 2.5em;
            padding: 1.25em;
        }

        .tile.timer-tile.minimal #timer-count {
            font-size: 1.5em;
        }

        #timer-title {
            color: hsl(from var(--text) h s l / 70%);
            font-size: 11px;
        }

        #timer-image {
            /* -gtk-icon-filter: brightness(10) saturate(100%) contrast(100%); /1* white *1/ */
            filter: brightness(10) saturate(100%) contrast(100%);
            /* black */
        }

        /* EMOJIES */
        .emoji-item {
            padding: 20px;
        }

        .emoji-item #emoji-name {
            font-size: 10px;
            color: hsl(from var(--text) h s l / 30%);
        }

        #context-menu.emoji row {
            padding: 3px;
        }

        #context-menu.emoji label {
            padding: 5px;
            border-radius: 3px;
        }

        #context-menu.emoji label.active {
            background: hsl(from var(--text) h s l / 10%);
        }

        /*ANIMATIONS*/
        @keyframes vanish-rotate {
            from {
                opacity: 1;
            }

            to {
                opacity: 0;
                transform: rotate(360deg);
            }

        }

        @keyframes rotate {
            from {
                transform: rotate(0deg);
                --start-rotation: 0deg;
            }

            to {
                transform: rotate(360deg);
                --start-rotation: 360deg;
            }

        }

        @keyframes ease-opacity {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }

        }

        @keyframes slide {
            from {
                transform: translate(0px, 0px);
            }

            to {
                transform: translate(-20px, 0px);
            }
        }

        @keyframes slide {
            from {
                transform: translate(0px, 0px);
            }

            to {
                transform: translate(-20px, 0px);
            }
        }
      '';
    };
  };
}
