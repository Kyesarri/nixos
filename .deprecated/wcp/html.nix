{
  # config,
  inputs,
  outputs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/wcp/html/main.html" = {
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
}
