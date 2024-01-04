{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "shaderbg";
  version = "unstable";

  src = fetchFromSourcehut {
    owner = "~mstoeckl";
    repo = "shaderbg";
    rev = "027d4f87fd542c79d4276b521e39025477b6d03e";
    hash = "sha256-/HtbS+vn69oEDVP4HDBvnmpkGRLz62j8lCZx+plrUeI=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    description = "";
    homepage = "https://git.sr.ht/~mstoeckl/shaderbg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
