{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "cockpit-podman";
  version = "98";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit-podman";
    rev = version;
    hash = "sha256-7Awlrt5be1FdewnLlR07DsU/+oDyY4a8qZIhuVw7WE4=";
    fetchSubmodules = true;
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [
    "cockpit_podman"
  ];

  meta = {
    description = "Cockpit UI for podman containers";
    homepage = "https://github.com/cockpit-project/cockpit-podman";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "cockpit-podman";
  };
}
