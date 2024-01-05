{...}: {
  home-manager.users.${user}.home.file.".config/wlogout/style.css" = {
    text = ''
      window {
          font-family: monospace;
          font-size: 14pt;
          color: #${config.colorscheme.colors.base06}; /* text */
          background-color: #${config.colorscheme.colors.base05};
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border: none;
          background-color: #${config.colorscheme.colors.base01};
          margin: 10px;
          transition: box-shadow 0.5s ease-in-out, background-color 0.5s ease-in-out;
      }

      button:hover {
          background-color: #${config.colorscheme.colors.base03};
      }

      button:focus {
          background-color: #cba6f7;
          color: #1e1e2e;
      }

      #lock {
          background-image: image(url("./lock.png"));
      }
      #lock:focus {
          background-image: image(url("./lock-hover.png"));
      }

      #logout {
          background-image: image(url("./logout.png"));
      }
      #logout:focus {
          background-image: image(url("./logout-hover.png"));
      }

      #suspend {
          background-image: image(url("./sleep.png"));
      }
      #suspend:focus {
          background-image: image(url("./sleep-hover.png"));
      }

      #shutdown {
          background-image: image(url("./power.png"));
      }
      #shutdown:focus {
          background-image: image(url("./power-hover.png"));
      }

      #reboot {
          background-image: image(url("./restart.png"));
      }
      #reboot:focus {
          background-image: image(url("./restart-hover.png"));
      }

    '';
  };
}
