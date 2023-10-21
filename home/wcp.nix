# TODO current codebase uses BBGGRRAA colours, waiting on a fix so this can work with my current configuration
# see https://github.com/milgra/wcp/issues/6
{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file.".config/wcp/html/main.html" = {
    text = ''
      <div id="main" class="fullscaleview">
        <div id="mainflex" class="fullscaleview colflex margin5">

        <div id="volumerow" class="row">
          <div id="mutebtn" class="button0" type="button" script="open-audio.sh">
            <div id="muteicon"/>
          </div>
          <div id="volumegap" class="vertgap10"/>
          <div id="volslider" class="slider"  type="slider" script="volume.sh">
            <div id="volsliderbar" class="sliderbar"/>
          </div>
        </div>

        <div id="horgap0" class="horgap10"/>

        <div id="backlightrow" class="row">
          <div id="displaybtn" class="button0" type="button" script="open-displays.sh">
            <div id="displayicon"/>
          </div>
          <div id="lcdgap" class="vertgap10"/>
          <div id="lcdslider" class="slider"  type="slider" script="brightness.sh">
            <div id="lcdsliderbar" class="sliderbar"/>
          </div>
        </div>

        <div id="horgap1" class="horgap10"/>

        <div id="wifirow" class="row">
          <div id="wifibtn" class="button0" type="button" script="open-wifi.sh">
            <div id="wifiicon"/>
          </div>
          <div id="wifigap" class="vertgap10"/>
          <div id="wifilabelback" class="labelback" type="button" script="open-wifi.sh">
            <div id="wifilabel" class="label" type="label" script="wifi-label.sh"/>
          </div>
        </div>

        <div id="horgap2" class="horgap10"/>

        <div id="bluetoothrow" class="row">
          <div id="bluetoothbtn" class="button0" type="button" script="open-bluetooth.sh">
            <div id="bluetoothicon"/>
          </div>
          <div id="btoothgap" class="vertgap10"/>
          <div id="btoothlabelbck" class="labelback" type="button" script="open-bluetooth.sh">
            <div id="btoothlabel" class="label" type="label" script="bluetooth-label.sh"/>
          </div>
        </div>

        <div id="horgap3" class="horgap10"/>

        <div id="sessionrow" class="rowflex">
          <div id="lockbtn" class="button" type="button" script="lock.sh">
            <div id="lockicon"/>
          </div>
          <div id="sessiongap0" class="vertgap10"/>
          <div id="logoutbtn" class="button" type="button" script="logout.sh">
            <div id="logouticon"/>
          </div>
          <div id="sessiongap1" class="vertgap10"/>
          <div id="suspendbtn" class="button" type="button" script="suspend.sh">
            <div id="suspendicon"/>
          </div>
          <div id="sessiongap2" class="vertgap10"/>
          <div id="rebootbtn" class="button" type="button" script="reboot.sh">
            <div id="rebooticon"/>
          </div>
          <div id="sessiongap3" class="vertgap10"/>
          <div id="shutdownbtn" class="button" type="button" script="shutdown.sh">
            <div id="shutdownicon"/>
          </div>
        </div>

        </div>
      </div>
    '';
  };

  home-manager.users.kel.home.file."dots/config/wcp/html/main.css" = {
    text = ''
      #main {
          border-radius: 10px;
          background-color: #${config.colorScheme.colors.base01}FF;
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
          background-color: #${config.colorScheme.colors.base02}FF;
      }

      .label {
          width: 100%;
          height: 100%;
          background-color: #00000000;
          margin-left: 5px;
          line-height: 25px;
          color: #${config.colorScheme.colors.base02}FF;
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
          background-color: #${config.colorScheme.colors.base04}DD;
          border-radius: 5px;
      }

      .sliderbar {
          width: 1%;
          height: 30px;
          background-color: #${config.colorScheme.colors.base06}DD;
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
