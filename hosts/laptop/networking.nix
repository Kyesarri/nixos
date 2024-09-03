{lib, ...}: {
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "nix-laptop";
  };
}
