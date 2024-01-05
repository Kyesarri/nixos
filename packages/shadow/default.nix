{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "shadow";
  version = "unstable-2023-06-28";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "danielfvm";
    repo = "shadow";
    rev = "bfba0ceaa3e05aeb5a86e9758641fb898033d69e";
    hash = "sha256-Zz94ufHEnGFbUDkX8PFVO95ZUveWBEr4w2fCimDXivw=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cairocffi
    glfw
    imageio
    mouse # not included in poetry-core? stumped here :)
    pillow
    pyopengl
    pyqt6
    screeninfo
    xcffib
  ];

  pythonImportsCheck = ["shadow_engine"];

  meta = with lib; {
    description = "A live and interactive wallpaper \"engine\" for Linux and Windows. It supports mixing various formats like glsl-shaders, images, videos and GIFs to create an amazing wallpaper. Additionally you can expand it's functionality with scripts";
    homepage = "https://github.com/danielfvm/shadow";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
