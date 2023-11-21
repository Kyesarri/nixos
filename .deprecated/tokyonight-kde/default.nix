{
  stdenv,
  lib,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "tokyonight-kde";
  version = "1e6d8a4e515be9f80959e0a7500bf1aede256dd7";

  src = fetchFromGitHub {
    owner = "nonetrix";
    repo = pname;
    rev = "1e6d8a4e515be9f80959e0a7500bf1aede256dd7";
    sha256 = "sha256-Uacbt86KsExXN6exsynCUrzY5AYkBk5SUDUWYPYEkL8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/color-schemes
    cp TokyoNight.colors $out/share/color-schemes

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tokyo Night color theme for KDE";
    homepage = "https://github.com/nonetrix/tokyonight-kde";
    license = licenses.mit;
    maintainers = [maintainers.kye];
    platforms = platforms.all;
  };
}
