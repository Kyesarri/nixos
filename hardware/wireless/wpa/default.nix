{
  config,
  pkgs,
  spaghetti,
  inputs,
  outputs,
  ...
}: {
  networking = {
    wireless.enable = true; # wpa
  };
}
