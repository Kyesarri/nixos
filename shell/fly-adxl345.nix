# https://mellow-3d.github.io/fly_adxl345_usb_general.html
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      dbus
      python313Packages.libusb-package
      python3
      gnumake
      gcc-arm-embedded
    ];
    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
    dbus = pkgs.dbus;
  }
