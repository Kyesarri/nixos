let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      (pkgs.python311Full.withPackages (python-pkgs: [
        python-pkgs.pandas
        python-pkgs.requests
        python-Packages.pyusb
      ]))
    ];
  }
