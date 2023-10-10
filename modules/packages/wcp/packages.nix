{pkgs ? import <nixpkgs> {}}: {
  wcp = import ./wcp {inherit pkgs;};
}
