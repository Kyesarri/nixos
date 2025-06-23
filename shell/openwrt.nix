/*
binutils bzip2 diff find flex gawk gcc-6+ getopt grep install libc-dev libz-dev
make4.1+ perl python3.7+ rsync subversion unzip which
*/
with import <nixpkgs> {}; let
  pythonPackages = python3Packages;
in
  pkgs.mkShell rec {
    name = "impurePythonEnv";
    venvDir = "../../.venv";
    buildInputs = [
      pythonPackages.python

      binutils
      bzip2
      diffutils
      uutils-findutils
      flex_2_5_35
      gawkInteractive
      libgccjit
      getopt
      gnugrep
      toybox

      linuxHeaders
      util-linux

      libz
      gnumake
      perl
      rsync
      subversion
      unzip
      which
    ];

    # Run this command, only after creating the virtual environment
    # postVenvCreation = ''
    #   unset SOURCE_DATE_EPOCH
    #   pip install -r requirements.txt
    # '';

    # Now we can execute any commands within the virtual environment.
    # This is optional and can be left out to run pip manually.
    postShellHook = ''
      # allow pip to install wheels
      unset SOURCE_DATE_EPOCH
    '';
  }
