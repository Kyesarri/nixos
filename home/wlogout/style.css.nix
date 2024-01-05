{
  user,
  config,
  pkgs,
  ...
}: {
  home-manager.users.${user}.home.file.".config/wlogout/style.css" = {
    text = ''
      * {
      	background-image: none;
      }

      window {
          font-family: Hasklug Nerd Font Regular;
          font-size: 14pt;
          color: #${config.colorscheme.colors.base06}; /* text */
          background-color: #${config.colorscheme.colors.base00}AA;
      }

      button {
          color: #${config.colorscheme.colors.base05}; /* text */
      	  background-color: #${config.colorscheme.colors.base01};
      	  border-style: none;
      	  border-width: 10px;
          margin: 10px;
      	  background-repeat: no-repeat;
      	  background-position: center;
      	  background-size: 25%; /* icon size */
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:focus, button:active, button:hover {
      	  background-color: #${config.colorscheme.colors.base02};
          outline-style: none;

      }

      #lock {
          background-image: url("/home/users/${user}/.config/wlogout/power.png");
          background-size: 100px 100px;
      }

      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
      }

      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
      }

      #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
      }

      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
      }

      #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
      }

      #gem {
          background-image: none;
      }

    '';
  };
}
