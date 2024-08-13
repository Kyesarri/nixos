{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  libglvnd,
  libpng,
  wayland-scanner,
  wayland,
  wayland-protocols,
  freetype,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "wcp";
  version = "0.77b";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "wcp";
    rev = version;
    url = "https://github.com/milgra/wcp/archive/refs/tags/0.77b.tar.gz";
    sha256 = "ufQvHlLD6p7Ix+NaKP0SsUMr5Hfq3yn+OvozQtX8je8=";
  };

  buildInputs = [
    meson
    ninja
    pkg-config
    cmake
    libglvnd
    libpng
    wayland-scanner
    wayland
    wayland-protocols
    freetype
    libxkbcommon
  ];

  meta = with lib; {
    description = "Script-driven control panel/system menu for wayland based window managers.";
    longDescription = ''
      Wayland control panel is an application for popup control menu, system menu or any kind of menu for UNIX-like operating systems.
      You can trigger it's appereance with a shortcut or with a button in the status bar. It can be structured via html, styled via css.
      1Button, label and slider values are coming from scripts and it can invoke scripts in case of interaction, it's totally configurable.
      By default it looks for config files under ~/.config/wcp/ and falls back to /usr/local/share/wcp.
    '';
    homepage = "https://github.com/milgra/wcp1";
    changelog = "https://github.com/milgra/wcp/releases";
    license = licenses.gpl3Plus;
    maintainers = [maintainers.kye];
    platforms = platforms.all;
  };
}
