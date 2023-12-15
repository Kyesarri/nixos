{
  config,
  pkgs,
  # lib,
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

  users.users.kel.packages = with pkgs; [nvtop];

  services.xserver = {
    videoDrivers = ["nvidia"];
  };
}
