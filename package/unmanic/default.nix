{
  lib,
  python3Packages,
  ffmpeg_6-full,
  fetchurl,
}: let
  pname = "unmanic";
in
  python3Packages.buildPythonApplication rec {
    inherit pname;
    version = "0.3.0";

    src = fetchurl {
      url = "https://github.com/Unmanic/unmanic/archive/refs/tags/0.3.0.tar.gz";
      hash = "";
    };
    nativeBuildInputs = with python3Packages; [
      schedule
      tornado
      marshmallow
      peewee
      peewee_migrate
      psutil
      requests
      requests_toolbelt
      py-cpuinfo
      JSON-log-formatter
      watchdog
      inquirer
      swagger-ui-bundle
    ];

    buildInputs = [
    ];

    propagatedUserEnvPkgs = [
    ];

    installPhase = '''';

    meta = {
      description = "Unmanic - Library Optimiser";
      homepage = "https://unmanic.app/";
      license = none;
      platforms = none;
      maintainers = [];
    };
  }
