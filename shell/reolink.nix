# messing around with reolink 520a firmwares
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      dbus
      python3
      mtdutils
      python313Packages.pipx
      binwalk
    ];
    # need some packages via pipx -
    # ubi_reader
    # pakler

    # in addition will need firmwares from reolink
    # https://support.reolink.com/c/rlc-510a-rlc-520a/?search=rlc-520a#7235835039278225004-download-f
    # otherwise if link not work try https://support.reolink.com/c/rlc-510a-rlc-520a/?search=rlc-520a
    nativeBuildInputs = with pkgs; [
      pkg-config
    ];
    dbus = pkgs.dbus;
  }
# extracted rootfs and app images
# proding around to gain ftp / telnet session which looks doable
# to rebuild images into one .pak file and see if the camera will accept the upgrade...

