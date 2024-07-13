# builds, TODO need to figure out scripts from https://github.com/knauth/goodix-521d-explanation under NIX - issue being usb
# using shell.nix in root of config, can get the device flashed / wiped, needs more work
# TODO
{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  python3,
  ninja,
  gusb,
  pixman,
  glib,
  nss,
  gobject-introspection,
  coreutils,
  cairo,
  libgudev,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
}:
stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.7";
  outputs = ["out" "devdoc"];

  src = fetchFromGitHub {
    owner = "Infinytum";
    repo = "libfprint";
    rev = version;
    url = "https://github.com/Infinytum/libfprint/archive/refs/tags/v1.90.7.tar.gz";
    sha512 = "TjrqXqG+dlPbS6E553zRNb4DLyQOCId3Xls2YoJeWXEEP4DTOoy+sA0Y/6KV9zt2dR7B9MLMBp7OBqXoxyfylg==";
  };

  postPatch = ''
    patchShebangs \
      tests/test-runner.sh \
      tests/unittest_inspector.py \
      tests/virtual-image.py \
      tests/umockdev-test.py \
      tests/test-generated-hwdb.sh
  '';
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gobject-introspection
  ];

  buildInputs = [
    gusb
    pixman
    glib
    nss
    cairo
    libgudev
  ];

  mesonFlags = [
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d"
    # Include virtual drivers for fprintd tests
    "-Ddrivers=all"
    # "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d" # disabling this lets the package install, required in source package from nixpkgs
  ];

  doCheck = false;
  nativeInstallCheckInputs = [
    (python3.withPackages (p: with p; [pygobject3]))
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ninjaCheckPhase

    runHook postInstallCheck
  '';

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
