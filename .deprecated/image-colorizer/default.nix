{
  lib,
  python3,
  fetchFromGitHub,
  python3Packages,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "image-colorizer";
  version = "unstable-2021-10-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kiddae";
    repo = "ImageColorizer";
    rev = "48623031e3106261093723cd536a4dae74309c5d";
    hash = "sha256-ucwo5DOMUON9HgQzXmh39RLQH4sWtSfYH7+UWfGIJCo=";
  };

  propagatedBuildInputs = with python3Packages; [pillow];

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = ["ImageColorizer"];

  meta = with lib; {
    description = "Make any wallpaper fit any terminal colorscheme";
    homepage = "https://github.com/kiddae/ImageColorizer";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "image-colorizer";
  };
}
