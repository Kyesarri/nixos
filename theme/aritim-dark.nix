#{ stdenv, fetchFromGitHub }:
with import <nixpkgs> {}; # bring all of Nixpkgs into scope
stdenv.mkDerivation rec
{
  pname = "arc-kde-theme";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "Mrcuve0";
    repo = "Aritim-Dark";
    rev = version;
    sha256 = "0wli16k9my7m8a9561545vjwfifmxm4w606z1h0j08msvlky40xw";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  outputHashMode = "recursive";
}
