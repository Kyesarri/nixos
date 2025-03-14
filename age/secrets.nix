let
  kel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFnfRc5Gx998u6eDONtNutO5McC2ggpuhePHG6Zr00p kel@nix-laptop";
  users = [kel];

  nix-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEYPPXbG3EGxGlcfFveZKgTDn5Y64eTFfa7B27hObwK root@nix-laptop";
  systems = [nix-laptop];
in {
  "secret1.age".publicKeys = [kel nix-laptop];
  "secret2.age".publicKeys = users ++ systems;
}
