let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.openssl
      (pkgs.python311Full.withPackages (python-pkgs: [
        python-pkgs.pyusb
        python-pkgs.python-periphery
        python-pkgs.spidev
        python-pkgs.crccheck
        python-pkgs.crcmod
        python-pkgs.pycryptodome
      ]))
    ];
  }
# shell for working with fprintd / goodix-fp-dump

