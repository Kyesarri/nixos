let
  kel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGEYPPXbG3EGxGlcfFveZKgTDn5Y64eTFfa7B27hObwK root@nix-laptop";
  users = [kel];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  systems = [system1];
in {
  "secret1.age".publicKeys = [kel system1];
  "secret2.age".publicKeys = users ++ systems;
}
