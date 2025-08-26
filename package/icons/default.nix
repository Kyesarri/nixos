{
  lib,
  gtk3,
  pastel,
  jdupes,
  gitUpdater,
  stdenvNoCC,
  kdePackages,
  libsForQt5,
  fetchFromGitHub,
  gnome-icon-theme,
  numix-icon-theme,
  hicolor-icon-theme,
  numix-icon-theme-circle,
}:
stdenvNoCC.mkDerivation rec {
  pname = "zafiro-icons";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = version;
    sha256 = "sha256-IbFnlUOSADYMNMfvRuRPndxcQbnV12BqMDb9bJRjnoU=";
  };

  dontDropIconThemeCache = true;

  dontPatchELF = true;

  dontRewriteSymlinks = true;

  dontWrapQtApps = true;

  buildInputs = [];

  nativeBuildInputs = [
    gtk3
    jdupes
    pastel
  ];

  propagatedBuildInputs = [
    kdePackages.breeze-icons
    gnome-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    hicolor-icon-theme
  ];

  # replace basic folder colours with our own

  # base0e as accent colour

  # base0a for some icons, used by symlink and others

  # pastel unused in theme currently

  # need to take a look at some embelems and fixup the faffff / fffffa colours

  postPatch = ''
    dA=`pastel darken 0.20 B072D1 | pastel format hex | cut -d"#" -f2`

    for file in $(find -name \*.svg); do
      substituteInPlace "$file" \
        --replace-quiet 'd8d8d8' '9DA0A2' \
        --replace-quiet 'ac9d93' '2E303E' \
        --replace-quiet '4dc7c9' 'DF5273' \
        --replace-quiet '59b6a4' '24A8B4' \
        --replace-quiet 'ffffff' 'CBCED0' \
        --replace-quiet '6f8a91' "6F6F70"
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    # remove light theme
    for theme in Dark; do
      cp -a $theme $out/share/icons/Zafiro-icons-$theme

      # remove unneeded files
      rm $out/share/icons/Zafiro-icons-$theme/_config.yml

      # remove files with non-ascii characters in name
      # https://github.com/zayronxio/Zafiro-icons/issues/111
      rm $out/share/icons/Zafiro-icons-$theme/apps/scalable/βTORRENT.svg

      # remove previews
      rm $out/share/icons/Zafiro-icons-$theme/previews/*

      gtk-update-icon-cache $out/share/icons/Zafiro-icons-$theme
    done

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {};

  meta = with lib; {
    description = "Icon pack flat with light colors";
    homepage = "https://github.com/zayronxio/Zafiro-icons";
    license = with licenses; [gpl3];
    platforms = platforms.linux;
    maintainers = with maintainers; [romildo];
  };
}
