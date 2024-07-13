{
  config,
  inputs,
  outputs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/wcp/html/main.css" = {
    text = ''
      #main {
          border-radius: 10px;
          background-color: #${config.colorScheme.palette.base01}FF;
      }

      .fullscaleview {
          height: 100%;
          width: 100%;
      }

      .colflex {
          display: flex;
          flex-direction: column;
          width: 100%;
          height: 100%;
      }

      .rowflex {
          display: flex;
          flex-direction: row;
          width: 100%;
          height: 100%;
      }

      .row {
          width: 100%;
          height: 30px;
          display: flex;
          flex-direction: row;
      }

      .flatrow {
          width: 100%;
          height: 30px;
      }

      .labelback {
          width: 100%;
          height: 30px;
          border-radius: 5px;
          background-color: #${config.colorScheme.palette.base02}FF;
      }

      .label {
          width: 100%;
          height: 100%;
          background-color: #00000000;
          margin-left: 5px;
          line-height: 25px;
          color: #${config.colorScheme.palette.base02}FF;
          font-size: 16px;
          font-family: "Terminus (TTF):style=Bold";
      }

      .button0 {
          width: 30px;
          height: 30px;
          background-color: #121212FF;
          border-radius: 5px;
      }

      .button {
          width: 100%;
          height: 30px;
          background-color: #121212FF;
          border-radius: 5px;
          align-items: center;
      }

      .slider {
          width: 100%;
          height: 30px;
          background-color: #${config.colorScheme.palette.base04}DD;
          border-radius: 5px;
      }

      .sliderbar {
          width: 1%;
          height: 30px;
          background-color: #${config.colorScheme.palette.base06}DD;
          border-radius: 5px;
      }

      .horgap10 {
          width: 100%;
          height: 5px;
      }

      .vertgap10 {
          width: 5px;
          height: 100%;
      }

      .margin5 {
          margin: 10px;
      }

      #muteicon {
          width: 30px;
          height: 30px;
          background-image: url("speaker.png");
          blocks: no;
      }

      #displayicon {
          width: 30px;
          height: 30px;
          background-image: url("display.png");
          blocks: no;
      }

      #wifiicon {
          width: 30px;
          height: 30px;
          background-image: url("wifi.png");
          blocks: no;
      }

      #bluetoothicon {
          width: 30px;
          height: 30px;
          background-image: url("bluetooth.png");
          blocks: no;
      }

      #lockicon {
          margin: auto;
          width: 30px;
          height: 30px;
          background-image: url("lock.png");
          blocks: no;
      }

      #logouticon {
          margin: auto;
          width: 30px;
          height: 30px;
          background-image: url("exit.png");
          blocks: no;
      }

      #suspendicon {
          margin: auto;
          width: 30px;
          height: 30px;
          background-image: url("suspend.png");
          blocks: no;
      }

      #shutdownicon {
          margin: auto;
          width: 30px;
          height: 30px;
          background-image: url("shutdown.png");
          blocks: no;
      }

      #rebooticon {
          margin: auto;
          width: 30px;
          height: 30px;
          background-image: url("reboot.png");
          blocks: no;
      }
    '';
  };
}
