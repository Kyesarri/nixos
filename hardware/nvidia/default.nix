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
    gwe # gpu overclocking
    nvtopPackages.full
  ];

  services.xserver.videoDrivers = ["nvidia"];
}
