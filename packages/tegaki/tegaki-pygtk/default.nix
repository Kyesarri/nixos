{
  lib,
  stdenv,
  fetchFromGitHub,
  python2,
}:
python2.pkgs.buildPythonApplication rec {
  pname = "tegaki-pygtk";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tegaki";
    repo = "tegaki";
    rev = "v${version}";
    sparseCheckout = ["tegaki-pygtk"];
    hash = "sha256-JTt1npGWue9xv5ViQ1bRx3M3cEmuQPUWvAWhm1wUvCY=";
  };

  sourceRoot = "source/tegaki-pygtk";

  installPhase = ''
    python setup.py install
  '';

  meta = with lib; {
    description = "Chinese and Japanese Handwriting Recognition";
    homepage = "https://github.com/tegaki/tegaki/tree/master/tegaki-python";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "tegaki-python";
    platforms = platforms.all;
  };
}
