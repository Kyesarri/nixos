# TODO errors when building, needs attention
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  cmake,
  glib,
  gusb,
  cairo,
  pixman,
  nss,
  gobject-introspection,
  gtk-doc,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.7";

  src = fetchFromGitHub {
    owner = "Infinytum";
    repo = "libfprint";
    rev = version;
    url = "https://github.com/Infinytum/libfprint/archive/refs/tags/v1.90.7.tar.gz";
    sha512 = "TjrqXqG+dlPbS6E553zRNb4DLyQOCId3Xls2YoJeWXEEP4DTOoy+sA0Y/6KV9zt2dR7B9MLMBp7OBqXoxyfylg==";
  };

  buildInputs = [
    meson
    pkg-config
    cmake
    glib
    gusb
    cairo
    pixman
    nss
    gobject-introspection
    gtk-doc
    ninja
  ];

  meta = with lib; {
    description = "This is an experimental libfprint driver implementation for Goodix drivers.";
    longDescription = ''
      libfprint was originally developed as part of an academic project at the
      University of Manchester with the aim of hiding differences between different
      consumer fingerprint scanners and providing a single uniform API to application
      developers. The ultimate goal of the fprint project is to make fingerprint
      scanners widely and easily usable under common Linux environments.
    '';
    homepage = "https://github.com/Infinytum/libfprint";
    changelog = "https://github.com/Infinytum/libfprint/tags";
    license = licenses.lgpl21Only;
    maintainers = [maintainers.kye];
    platforms = platforms.all;
  };
}
