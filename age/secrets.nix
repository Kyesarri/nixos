let
  # users
  kel-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFnfRc5Gx998u6eDONtNutO5McC2ggpuhePHG6Zr00p kel@nix-laptop";
  kel-erying = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMON98uxNe7PXNbMMDiJbjqaz/qvNACfWsBW24KZGiWR kel@nix-erying";

  # systems
  nix-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEYPPXbG3EGxGlcfFveZKgTDn5Y64eTFfa7B27hObwK root@nix-laptop";
  nix-erying = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcItUOpimL/3wF2qj27C8/58s0ChrC9xauvDgyX0SPC root@nixos";

  users = [kel-laptop kel-erying];
  systems = [nix-laptop nix-erying];
  #
in {
  "secret1.age".publicKeys = users ++ systems;
  "secret2.age".publicKeys = users ++ systems;
}
