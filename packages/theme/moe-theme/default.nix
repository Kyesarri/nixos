{
  stdenvNoCC
, lib
, fetchFromGitLab
, gitUpdater
}:

stdenvNoCC.mkDerivation
{
  pname = "moe-theme";
  version = "";

  src = fetchFromGitLab
  {
    owner = "jomada";
    repo = "moe-theme";
    rev = "0eae9f1d6a7f01ff410c8845940b69403706c15f";
    sha256 = "0pfam2n3jpzqyvnk9r6pyga014v6cisslvf7a3gc09pdsssgavc9";
  };

  buildPhase = ''
    runHook preBuild
    cd kde
    mkdir -p aurorae/themes
    mv aurorae/Sweet-Dark aurorae/themes/Sweet-Dark
    mv aurorae/Sweet-Dark-transparent aurorae/themes/Sweet-Dark-transparent
    rm aurorae/.shade.svg
    mv colorschemes color-schemes
    mkdir -p plasma/look-and-feel
    mv look-and-feel plasma/look-and-feel/com.github.eliverlara.sweet
    mv sddm sddm-Sweet
    mkdir -p sddm/themes
    mv sddm-Sweet sddm/themes/Sweet
    mv cursors icons
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share
    cp -r Kvantum aurorae color-schemes icons konsole plasma sddm $out/share
    runHook postInstall
  '';

#  installPhase =
#  ''
#    runHook preInstall

#    mkdir -p $out/share/plasma/desktoptheme
#    mkdir -p $out/share/plasma/look-and-feel
#    mkdir -p $out/share/color-schemes
#    mkdir -p $out/share/konsole
#
#    cp -R MoeDark $out/share/plasma/desktoptheme
#    cp -R Moe-Global/Moe MoeDark-Global/Moe-Dark $out/share/plasma/look-and-feel
#    cp -R color-schemes/Moe.colors $out/share/color-schemes
#    cp -R konsole/Moe.colorscheme $out/share/konsole
#    runHook postInstall
#  '';


  # passthru.updateScript = gitUpdater { };

  meta = with lib;
  {
    description = "moe-theme";
    homepage = "https://gitlab.com/jomada/moe-theme/";
#    license = GPL-3.0-or-later;
    platorms = platforms.linux';
    maintainers = with maintainers; [ kye ];
  };
}
