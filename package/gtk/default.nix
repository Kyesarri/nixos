{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-themes-extra,
  gtk-engine-murrine,
  inkscape,
  jdupes,
  sassc,
}: let
  pname = "jasper-gtk-theme";
in
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "0-unstable-2025-04-02";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Jasper-gtk-theme";
      rev = "71cb99a6618d839b1058cb8e6660a3b2f63aca70";
      hash = "sha256-ZWPUyVszDPUdzttAJuIA9caDpP4SQ7mIbCoczxwvsus=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    buildInputs = [
      gnome-themes-extra
      inkscape
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    /*
    background_light='#FFFFFF'
    background_dark='#2C2C2C'
    background_darker='#3C3C3C'
    background_alt='#464646'
    titlebar_light='#F2F2F2'
    titlebar_dark='#242424'
    */

    # so this isn't working once theme is built

    # will also require generating assets once again...
    # nope, just sed over all the .svg

    # need to patch gtkrc-Dark-default
    postPatch = ''
      patchShebangs .
      for file in $(find -name gtkrc.sh); do
        substituteInPlace "$file" \
          --replace-fail '009688' \
                         'B072D1' \
          --replace-fail 'FFFFFF' \
                         'FFFFFF' \
          --replace-fail '2C2C2C' \
                         '2E303E' \
          --replace-fail '3C3C3C' \
                         '1C1E26' \
          --replace-fail '464646' \
                         '6F6F70' \
          --replace-fail '242424' \
                         '6F6F70'
      done
      for file in $(find -name gtkrc-Dark-default); do
        substituteInPlace "$file" \
          --replace-warn '009688' \
                         'B072D1' \
          --replace-warn 'FFFFFF' \
                         'FFFFFF' \
          --replace-warn '2C2C2C' \
                         '2E303E' \
          --replace-warn '3C3C3C' \
                         '1C1E26' \
          --replace-warn '464646' \
                         '6F6F70' \
          --replace-warn '242424' \
                         '6F6F70'
      done
      # replace colours in source svg files
      for file in $(find -name \*.svg); do
        substituteInPlace "$file" \
          --replace-warn '009688' \
                         'B072D1' \
          --replace-warn '60D6CB' \
                         'B072D1' \
          --replace-warn '212121' \
                         '1C1E26' \
          --replace-warn '3c3c3c' \
                         '2E303E' \
          --replace-warn '2A2A2A' \
                         '232530' \
          --replace-warn '6E6E6E' \
                         '6F6F70' \
          --replace-warn '4DB6AC' \
                         'B072D1'
      done
      # now for _color-palette-default.scss
      for file in $(find -name _color-palette-default.scss); do
        substituteInPlace "$file" \
          --replace-warn '009688' \
                         'B072D1'
      done
      rm /build/source/src/assets/gtk/assets/*
      rm /build/source/src/assets/gtk-2.0/assets/*
      rm /build/source/src/assets/gtk-2.0/assets-Dark/*
      cd /build/source/src/assets/gtk && ./render-assets.sh
      cd /build/source/src/assets/gtk-2.0 && ./render-assets.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes/

      name= HOME="$TMPDIR" /build/source/install.sh --color dark --size compact --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "Modern and clean Gtk theme";
      homepage = "https://github.com/vinceliuice/Jasper-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = [lib.maintainers.romildo];
    };
  }
