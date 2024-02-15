{
  config,
  pkgs,
  user,
  inputs,
  outputs,
  ...
}: {
  networking = {
    wireless.enable = true;
    networkmanager.enable = true;
  };
}
