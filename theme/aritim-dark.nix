

#with import <nixpkgs> {}; # bring all of Nixpkgs into scope

#let pkgs = import <nixpkgs> {}; in
{ stdenv, fetchFromGitHub }:
#with (import <nixpkgs> {});

#{ lib, pkgs, fetchFromGitHub, ... }:
#let
  stdenv.mkDerivation rec
  {
  pname = "aritim-dark";
  version = "0.7";
  src = fetchFromGitHub {
    owner = "Mrcuve0";
    repo = "Aritim-Dark";
    rev = "0.7";
    sha256 = "0wli16k9my7m8a9561545vjwfifmxm4w606z1h0j08msvlky40xw";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  outputHashMode = "recursive";
  }

