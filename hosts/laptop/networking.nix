{lib, ...}: {
  networking = {
    useDHCP = lib.mkDefault true;
    networking.hostName = "nix-laptop";
  };
}
