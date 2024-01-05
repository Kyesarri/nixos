{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  wayland,
  pkg-config,
  cmake,
}:
#> CMake Warning:
#>   Ignoring extra path from command line:
#>
#>    ".."
#>
#>
#> CMake Error: The source directory "/build/source" does not appear to contain CMakeLists.txt.
stdenv.mkDerivation rec {
  pname = "shaderbg";
  version = "unstable";

  dontFixCmake = true;
  src = fetchFromSourcehut {
    owner = "~mstoeckl";
    repo = "shaderbg";
    rev = "027d4f87fd542c79d4276b521e39025477b6d03e";
    hash = "sha256-/HtbS+vn69oEDVP4HDBvnmpkGRLz62j8lCZx+plrUeI=";
  };

  installPhase = ''make install DESTDIR=$out'';

  nativeBuildInputs = [
    cmake
    pkg-config
    meson
    ninja
    wayland
  ];

  meta = with lib; {
    description = "";
    homepage = "https://git.sr.ht/~mstoeckl/shaderbg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
