# TODO error wayland-egl not found, poking around to fix
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
}:
stdenv.mkDerivation rec {
  pname = "libfprint";
  version = "1.90.7";

  src = fetchFromGitHub {
    owner = "Infinytum";
    repo = "libfprint";
    rev = version;
    url = "https://github.com/Infinytum/libfprint/archive/refs/tags/v1.90.7.tar.gz";
    sha512 = "21642bcdac35b82cd3f56130603d09ebe62b321123f58ce4a491b8fa8f545ae86a7c3d670b212af474d561123efa91f0383ad416b07c3ce1d4df0d292e77bb94";
  };

  buildInputs = [
    meson
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
