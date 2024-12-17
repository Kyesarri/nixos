{
  config,
  pkgs,
  ...
}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    nvtopPackages.full
    tuxclocker-plugins
  ];

  services.xserver.videoDrivers = ["nvidia"];
}
