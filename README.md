<p align="center"> <font size="16">
🍝 nixos
</font>
</p>

[<img src="screenshots/header.readme.jpg" />](screenshots/header.readme.jpg)

<details>
    <summary> <p align="center"> <font size="4"> my public nixos configuration, system specific configs for...
</font></p></summary>
<p align="center">
<table>
  <tr>
    <th>machine</th>
    <th>cpu</th>
    <th>gpu</th>
    <th>use case</th>
  </tr>
  <tr>
    <td>serv</td>
    <td>9900k</td>
    <td>igpu</td>
    <td>file server & container host</td>
  </tr>
  <tr>
    <td>erying</td>
    <td>1370p es</td>
    <td>igpu</td>
    <td>container host</td>
  </tr>
  <tr>
    <td>laptop</td>
    <td>4800hs</td>
    <td>gtx1650 | igpu</td>
    <td>main machine, general purpose</td>
  </tr>
  <tr>
    <td>notebook</td>
    <td>n3700</td>
    <td>igpu</td>
    <td>3d printer</td>
  </tr>
  <tr>
    <td>desktop</td>
    <td>13900kf</td>
    <td>rtx3070</td>
    <td>gaming</td>
  </tr>
</table>

</details>
</p>

## what and why?
these configs are both practical and a learning experience

configs assume a single user, home-manager options don't have any applicable configs for multiple users

configurations cover my daily drivers, multiple headless machines and repurposed hardware

there are configurations for multiple lan services (home assistant, adguard and many more) running in podman / nspawn containers along with some internet facing services (ghost, plex, jellyfin and so on)

i've taken snippits of code from all over the web (added links where i remembered to... sorry!), written much of my own and want to contribute my configs hoping they will help others.

comments are included in many modules, some simple, some chicken-scratch from me figuring things out. configurations may not be optimal in some areas but (most) are working currently

my configs are in flux, readme won't be upto date in places GLHF!

## screenshots

take a [peek](screenshots/README.md)

## included
see [standard.nix](hosts/standard.nix) or [headless.nix](hosts/headless.nix) for base packages

in addition any of the hosts [default.nix](hosts/laptop/default.nix) for additional packages with configuration.
modules are having options (slowly) added, see [/home/hypr/default.nix](home/hypr/default.nix)

### containers
have a gander at the [readme](containers/README.md)

## about
programs in /home [home/pkgname](home/kitty/default.nix) have bindings, themes and exec at boot where applicable. add / remove in [hosts/hostname/default.nix](hosts/laptop/default.nix) FIXME these are changing as per above

some hypr keybind conflicts will apply if you are using multiple applications for the same purpose (wofi / ulauncher for example) I'll eventually add some options to (hopefully) avoid this.

## use
clone this repository to your ~/ and not /etc/nixos

my configs are be portable to default /etc/nixos configs however some tweaks would be required

 ```cd ~ && git clone https://codeberg.org/kye/nixos```

copy contents of your /etc/nixos/hardware-configuration.nix and replace the contents of a hosts [hardware.nix](hosts/laptop/hardware.nix) of which you plan to use

open the root [flake.nix](flake.nix), change the ```user = "kel";``` line to your own username, this will change all home-manager and nixos config files

run ```sudo nixos-rebuild switch --flake /home/username/nixos#hostname --show-trace``` while changing username and hostname to what you have configured

## issues
things may / will fail, i'm happy to helpout when my time permits. raise an issue on codeberg - github is my mirror currently

### secrets
secrets won't work out the box, quick workaround would be replacing my ~/nixos/secrets.json with ~/secrets.example/example.secrets.json

### home-manager
will complain about files in the way in your ```.config```, delete the files home-manager listed and run another rebuild
TODO script to delete dirs on first rebuild