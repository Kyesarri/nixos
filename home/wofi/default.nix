{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    #
    programs.wofi = {
      enable = true;
      settings = {
        width = 500;
        height = 300;
        always_parse_args = true;
        show_all = false;
        print_command = true;
        insensitive = true;
      };
    };
    #
    home.file.".config/hypr/per-app/wofi.conf" = {
      text = ''
        bind = $mainMod, R, exec, wofi --show run
      '';
    };
    #
    home.file.".config/wofi/style.css" = {
      text = ''
        window {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base00};
          opacity: 1.0;
          font-size: 15px;
          font-family: JetBrainsMonoNL NF;
          border-radius: 10px;
          border: 5px solid #${config.colorScheme.palette.base03};
        }

        #outer-box {
          margin: 5px;
          border: 5px;
          border-radius: 10px;
        }

        #input {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base01};
          color: #${config.colorScheme.palette.base05};
          font-size: 15px;
          border: 5px;
          border-radius: 10px;
        }

        #inner-box {
          background-color: #${config.colorScheme.palette.base00};
          border: 5px;
          border-radius: 10px;
        }

        #scroll {
          font-size: 15px;
          color: #${config.colorScheme.palette.base0F};
          margin: 10px;
          border-radius: 5px;
        }

        #scroll label {
          margin: 0px 0px;
        }

        #entry {
          margin: 5px;
          background-color: #${config.colorScheme.palette.base01};
          border-radius: 10px;
          border: 5px;
        }
        #entry:selected {
          background-color: #${config.colorScheme.palette.base02};
          border: 5px solid #${config.colorScheme.palette.base03};
          border-radius: 10px;
          border: 5px;
        }

        #img {
          margin: 5px;
          border-radius: 5px;
        }

        #text {
          margin: 2px;
          border: none;
          color: #${config.colorScheme.palette.base05};
        }
      '';
    };
  };
}
