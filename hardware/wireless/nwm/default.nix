{
  config,
  pkgs,
  user,
  inputs,
  outputs,
  ...
}: {
  networking = {
    # wireless.enable = true;
    networkmanager.enable = true;
  };
  users.users.${user}.packages = with pkgs; [networkmanagerapplet];
}
