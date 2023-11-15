# TODO wait for a future release to fix argb values, need to write my own hyprland config for this, same as ags - write to pipe commands
# commands are screwy, need to investigate further here as I don't believe this is compatible with hypr
{
  lib,
  stdenv,
  pkg-config,
  cmake,
  fetchFromGitHub,
  typescript,
  libglvnd,
  nodejs_20,
  meson,
  libpng,
  gjs,
  gtk3,
  gtk-layer-shell,
  upower,
  networkmanager,
  gobject-introspection,
  libdbusmenu-gtk3,
  ninja,
  wayland,
  wayland-protocols,
  freetype,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "sov";
  version = "0.92b";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = "wcp";
    rev = version;
    url = "https://github.com/milgra/sov/releases/download/0.93/sov-0.93.tar.xz";
    sha256 = "1L5D0pzcXbkz3VS7VB6ID8BJEbGeNxjo3xCr71CGcIo=";
  };

  buildInputs = [
    meson
    pkg-config
    cmake
    libglvnd
    libpng
    wayland
    wayland-protocols
    freetype
    libxkbcommon
    ninja
    nodejs_20
    #gnome-bluetooth
  ];

  meta = with lib; {
    description = "Sway Overview - An overlay that shows schemas for all workspaces to make navigation in sway easier.";
    longDescription = ''
      Sway overview is an overview applciation for the sway tiling window manager.
      Tiling window managers are about simplicity so by default they don't have any kind of overview feature.
      It is okay under five workspaces because you can just remember where specific windows were opened but over 5 workspaces it can get really complicated.
      Sway overview draws a schematic layout of all your workspaces on each output. It contains all windows, window titles and window contents.
      Thumbnail based overview solutions can become confusing quickly when the thumbnails become too small to recognize, sway overview won't.
      The common usage of Sway overview is to bound its appereance to the desktop switcher button with a little latency.
      Sway overview can be structured via html, styled via css.
    '';
    homepage = "https://github.com/milgra/wcp1";
    changelog = "https://github.com/milgra/wcp/releases";
    license = licenses.gpl3Plus;
    maintainers = [maintainers.kye];
    platforms = platforms.all;
  };
}
