#  gobject-introspection,
#  coreutils,
#  cairo,
#  libgudev,
#  gtk-doc,
#  docbook-xsl-nons,
#  docbook_xml_dtd_43,
# builds, TODO need to figure out scripts from https://github.com/knauth/goodix-521d-explanation under NIX - issue being usb
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  pkg-config,
  glib,
  gusb,
  cairo,
  pixman,
  nss,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gobject-introspection,
  gtk-doc,
}:
stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.7";

  src = fetchFromGitHub {
    owner = "Infinytum";
    repo = "libfprint";
    rev = "v${version}";
    hash = "sha256-g/yczzCZEzUKV2uFl1MAPL1H/R2QJSwxgppI2ftt9QI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    glib
    gusb
    cairo
    pixman
    nss
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
    gtk-doc
  ];

  meta = with lib; {
    description = "Library for fingerprint readers";
    homepage = "https://github.com/Infinytum/libfprint/";
    changelog = "https://github.com/Infinytum/libfprint/blob/${src.rev}/NEWS";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [];
  };
}
