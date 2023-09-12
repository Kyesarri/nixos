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


  passthru.updateScript = gitUpdater { };

  meta = with lib;
  {
    description = "moe-theme";
    homepage = "https://gitlab.com/jomada/moe-theme/";
#    license = GPL-3.0-or-later;
    platorms = platforms.linux';
    maintainers = with maintainers; [ kye ];
  };
}
