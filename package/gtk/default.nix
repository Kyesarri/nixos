{
  gnome-themes-extra,
  gtk-engine-murrine,
  fetchFromGitHub,
  stdenvNoCC,
  inkscape,
  jdupes,
  pastel,
  sassc,
  lib,
}: let
  pname = "jasper-gtk-theme";
in
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "0-unstable-2025-04-02";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "Jasper-gtk-theme";
      rev = "3f7059d031744bffa39a44c8af795767f59f7c66";
      hash = "sha256-4AqF8BgAuh6LF0LHDYlubbnq5d3S5tm/7LaGX/h0AJw=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
      pastel
    ];

    buildInputs = [
      gnome-themes-extra
      inkscape
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    /*
    first generate accent colour shades, taking our base0e colour
    making it darker and lighter, saving each to a variable

    next we replace colours in specific files with our shades TODO add grey
    script here and sub in for hard-coded values

    also need to add nix-colors instead of hard coded values

    may need to take a look at our base16 scheme and create our own
    reasoning this theme may not be similar enough to other themes
    coding for one scheme without trying others may cause
    different schemes to look like crap

    alternative is to have this colour accent as an option to be passed in here

    need to replace FFFFFF with our themes base06

    keyboard.scss has some values hard coded too

    ; #4b4b4b
    ; #707070
    ; #1d1d1d

    may need to look for rgb colours in .css too fml

    pastel can easily convert hex to rgb
    */
    postPatch = ''
      darkA=$(pastel darken 0.33 B072D1 | pastel format hex | cut -d"#" -f2)

      lightA=$(pastel lighten 0.33 B072D1 | pastel format hex | cut -d"#" -f2)

      for file in $(find -name gtkrc.sh); do
        substituteInPlace "$file" \
          --replace-quiet '009688' "$lightA" \
          --replace-quiet '4DB6AC' 'B072D1' \
          --replace-quiet '60D6CB' "$darkA" \
          --replace-quiet '212121' '1c1e26' \
          --replace-quiet '242424' '1d1f27' \
          --replace-quiet '272727' '1e2029' \
          --replace-quiet '2A2A2A' '1f212a' \
          --replace-quiet '2C2C2C' '20222b' \
          --replace-quiet '2F3138' '21232c' \
          --replace-quiet '303030' '22242e' \
          --replace-quiet '373840' '23252f' \
          --replace-quiet '373737' '242630' \
          --replace-quiet '393939' '252732' \
          --replace-quiet '3C3C3C' '262833' \
          --replace-quiet '404249' '272934' \
          --replace-quiet '464646' '282a36' \
          --replace-quiet '4D4D4D' '292b37' \
          --replace-quiet '525252' '2a2c39' \
          --replace-quiet '636363' '2b2d3a' \
          --replace-quiet '6E6E6E' '2c2e3b' \
          --replace-quiet '757575' '2e303e'
      done

      for file in $(find -name gtkrc-Dark-default); do
        substituteInPlace "$file" \
          --replace-quiet '009688' "$lightA" \
          --replace-quiet '4DB6AC' 'B072D1' \
          --replace-quiet '60D6CB' "$darkA" \
          --replace-quiet '212121' '1c1e26' \
          --replace-quiet '242424' '1d1f27' \
          --replace-quiet '272727' '1e2029' \
          --replace-quiet '2A2A2A' '1f212a' \
          --replace-quiet '2C2C2C' '20222b' \
          --replace-quiet '2F3138' '21232c' \
          --replace-quiet '303030' '22242e' \
          --replace-quiet '373840' '23252f' \
          --replace-quiet '373737' '242630' \
          --replace-quiet '393939' '252732' \
          --replace-quiet '3C3C3C' '262833' \
          --replace-quiet '404249' '272934' \
          --replace-quiet '464646' '282a36' \
          --replace-quiet '4D4D4D' '292b37' \
          --replace-quiet '525252' '2a2c39' \
          --replace-quiet '636363' '2b2d3a' \
          --replace-quiet '6E6E6E' '2c2e3b' \
          --replace-quiet '757575' '2e303e'
      done

      for file in $(find -name \*.svg); do
        substituteInPlace "$file" \
          --replace-quiet '009688' "$lightA" \
          --replace-quiet '4DB6AC' 'B072D1' \
          --replace-quiet '60D6CB' "$darkA" \
          --replace-quiet '212121' '1c1e26' \
          --replace-quiet '242424' '1d1f27' \
          --replace-quiet '272727' '1e2029' \
          --replace-quiet '2A2A2A' '1f212a' \
          --replace-quiet '2C2C2C' '20222b' \
          --replace-quiet '2F3138' '21232c' \
          --replace-quiet '303030' '22242e' \
          --replace-quiet '373840' '23252f' \
          --replace-quiet '373737' '242630' \
          --replace-quiet '393939' '252732' \
          --replace-quiet '3C3C3C' '262833' \
          --replace-quiet '404249' '272934' \
          --replace-quiet '464646' '282a36' \
          --replace-quiet '4D4D4D' '292b37' \
          --replace-quiet '525252' '2a2c39' \
          --replace-quiet '636363' '2b2d3a' \
          --replace-quiet '6E6E6E' '2c2e3b' \
          --replace-quiet '757575' '2e303e'
      done

      for file in $(find -name _color-palette-default.scss); do
        substituteInPlace "$file" \
          --replace-quiet '009688' "$lightA" \
          --replace-quiet '4DB6AC' 'B072D1' \
          --replace-quiet '60D6CB' "$darkA" \
          --replace-quiet '212121' '1c1e26' \
          --replace-quiet '242424' '1d1f27' \
          --replace-quiet '272727' '1e2029' \
          --replace-quiet '2A2A2A' '1f212a' \
          --replace-quiet '2C2C2C' '20222b' \
          --replace-quiet '2F3138' '21232c' \
          --replace-quiet '303030' '22242e' \
          --replace-quiet '373840' '23252f' \
          --replace-quiet '373737' '242630' \
          --replace-quiet '393939' '252732' \
          --replace-quiet '3C3C3C' '262833' \
          --replace-quiet '404249' '272934' \
          --replace-quiet '464646' '282a36' \
          --replace-quiet '4D4D4D' '292b37' \
          --replace-quiet '525252' '2a2c39' \
          --replace-quiet '636363' '2b2d3a' \
          --replace-quiet '6E6E6E' '2c2e3b' \
          --replace-quiet '757575' '2e303e'
      done

      # we want to remove the bundled pre-rendered assets
      # as the scripts wont generate new assets with the old ones in place

      rm /build/source/src/assets/gtk/assets/*
      rm /build/source/src/assets/gtk-2.0/assets/*
      rm /build/source/src/assets/gtk-2.0/assets-Dark/*
      # rm /build/source/src/assets/cinnamon/assets/*
      # rm /build/source/src/assets/cinnamon/assets-Dark/*

      # we're using sed here instead of subinplace as we only want to replace
      # a specific string on specific lines, running over these whole files
      # will break how these scripts function

      # render-assets.sh will call make-assets.sh we don't need to execute make-assets.sh directly

      patchShebangs .

      cd /build/source/src/assets/gtk
      sed -i -e '7 s/009688/B072D1/' ./make-assets.sh
      sed -i -e '8 s/4DB6AC/B072D1/' ./make-assets.sh
      ./render-assets.sh

      cd /build/source/src/assets/gtk-2.0
      sed -i -e '9 s/009688/B072D1/' ./make-assets.sh
      sed -i -e '10 s/4DB6AC/B072D1/' ./make-assets.sh
      ./render-assets.sh

      # cd /build/source/src/assets/cinnamon
      # sed -i -e '7 s/009688/B072D1/' ./make-assets.sh
      # sed -i -e '8 s/4db6ac/B072D1/' ./make-assets.sh
    '';

    # now for this bastard
    # so we have output a gradient to file 'grey' using two colours from our scheme
    # we now want to modify line by line the original colours and replace
    # with ours which are in the correct order yay!

    # this is a simple, boring, horrible method for doing what i want but idk, not ready to learn a better method just yet
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes/

      name= HOME="$TMPDIR" /build/source/install.sh --color dark --size compact --libadwaita --dest $out/share/themes

      pastel gradient 2E303E 1C1E26 -n 19 | pastel format hex | cat > grey

      for file in $(find -name \*.css); do
        substituteInPlace "$file" \
          --replace-quiet '#FAFAFA' "sed -n 1p grey" \
          --replace-quiet '#F2F2F2' "sed -n 2p grey" \
          --replace-quiet '#EEEEEE' "sed -n 3p grey" \
          --replace-quiet '#DDDDDD' "sed -n 4p grey" \
          --replace-quiet '#CCCCCC' "sed -n 5p grey" \
          --replace-quiet '#BFBFBF' "sed -n 6p grey" \
          --replace-quiet '#A0A0A0' "sed -n 7p grey" \
          --replace-quiet '#9E9E9E' "sed -n 8p grey" \
          --replace-quiet '#868686' "sed -n 9p grey" \
          --replace-quiet '#727272' "sed -n 10p grey" \
          --replace-quiet '#555555' "sed -n 11p grey" \
          --replace-quiet '#464646' "sed -n 12p grey" \
          --replace-quiet '#3C3C3C' "sed -n 13p grey" \
          --replace-quiet '#2C2C2C' "sed -n 14p grey" \
          --replace-quiet '#242424' "sed -n 15p grey" \
          --replace-quiet '#212121' "sed -n 16p grey" \
          --replace-quiet '#121212' "sed -n 17p grey" \
          --replace-quiet '#0F0F0F' "sed -n 18p grey" \
          --replace-quiet '#030303' "sed -n 19p grey"
      done

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
    # fixupPhase = ''

    # '';
    meta = {
      description = "Modern and clean Gtk theme";
      homepage = "https://github.com/vinceliuice/Jasper-gtk-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.unix;
      maintainers = [];
    };
  }
/*
// Default Theme Color Palette

// Red
$red-light: #F44336;
$red-dark: #E53935;

// Pink
$pink-light: #F06292;
$pink-dark: #EC407A;

// Purple
$purple-light: #BA68C8;
$purple-dark: #AB47BC;

// Blue
$blue-light: #5b9bf8;
$blue-dark: #3c84f7;

// Teal
$teal-light: #4DB6AC;
$teal-dark: #009688;

// Green
$green-light: #95dbc2;
$green-dark: #87c7b0;

// Yellow
$yellow-light: #FBC02D;
$yellow-dark: #FFD600;

// Orange
$orange-light: #FF8A65;
$orange-dark: #FF7043;

// Grey
$grey-050: #c2c5c7;
$grey-100: #b8bbbe;
$grey-150: #aeb2b5;
$grey-200: #a4a8ab;
$grey-250: #9a9ea2;
$grey-300: #919599;
$grey-350: #888c90;
$grey-400: #7e8287;
$grey-450: #75797e;
$grey-500: #6c7076;
$grey-550: #63676d;
$grey-600: #5b5f65;
$grey-650: #52565c;
$grey-700: #4a4d54;
$grey-750: #42454c;
$grey-800: #3a3d44;
$grey-850: #32353c;
$grey-900: #2a2d35;
$grey-950: #23252d;

// White
$white: #FFFFFF;

// Black
$black: #000000;

// Button
$button-close: #fd5f51;
$button-max: #38c76a;
$button-min: #fdbe04;

// Theme
$default-light: $teal-light;
$default-dark: $teal-dark;
*/

