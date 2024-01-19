{
  config,
  pkgs,
  # lib,
  user,
  ...
}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  users.users.${user}.packages = with pkgs; [nvtop];

  services.xserver = {
    videoDrivers = ["nvidia"];
  };
}
