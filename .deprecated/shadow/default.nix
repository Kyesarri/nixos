{
  lib,
  python3,
  fetchFromGitHub,
  python3Packages,
  # python312Packages,
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
    # python312Packages.devtools
    # python312Packages.pyautogui # mouse not included in poetry-core?
  ];

  propagatedBuildInputs = [
    python3.pkgs.cairocffi
    python3.pkgs.glfw
    python3.pkgs.imageio
    python3.pkgs.pillow
    python3.pkgs.pyopengl
    python3.pkgs.pyqt6
    python3.pkgs.screeninfo
    python3.pkgs.xcffib
  ];

  # pythonImportsCheck = ["shadow_engine"];

  meta = with lib; {
    description = "A live and interactive wallpaper \"engine\" for Linux and Windows. It supports mixing various formats like glsl-shaders, images, videos and GIFs to create an amazing wallpaper. Additionally you can expand it's functionality with scripts";
    homepage = "https://github.com/danielfvm/shadow";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
  };
}
