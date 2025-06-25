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
      # line 1
      binutils # binutils
      bzip2 # bzip2
      diffutils # diff
      uutils-findutils # find
      flex_2_5_35 # flex
      gawkInteractive # gawk
      libgccjit # gcc-6+
      getopt # getopt
      gnugrep # grep
      toybox # install

      linuxHeaders # libc-dev
      util-linux # libc-dev

      libz # libz-dev

      # line 2
      gnumake # make4.1+
      perl # perl
      pythonPackages.python # python3.7+
      rsync # rsync
      subversion # subversion
      unzip # unzip
      which # which

      # additional packages
      ncurses
      pkg-config

      libev
      libpam-wrapper
      libtirpc
      elfutils
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
