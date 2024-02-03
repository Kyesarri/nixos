{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "wallgen";
  version = "unstable-2023-10-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SubhrajitPrusty";
    repo = "wallgen";
    rev = "2a05e2acd3ff05a313b093dabb270655f35c579a";
    hash = "sha256-0ZNID1pw8X0vceXmXCbi9y04f+EJDRkWVu2nvSN+Atk=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
    python3.pkgs.cython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    flask
    gevent
    loguru
    numpy
    pillow
    scikit-image
    scipy
  ];

  meta = with lib; {
    description = "Generate HQ poly wallpapers";
    homepage = "https://github.com/SubhrajitPrusty/wallgen";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "wallgen";
  };
}
