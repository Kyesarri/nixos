{
  config,
  pkgs,
  user,
  inputs,
  outputs,
  ...
}: {
  networking = {
    wireless.enable = true; # wpa
  };
}
