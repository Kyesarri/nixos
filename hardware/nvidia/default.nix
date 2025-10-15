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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  environment.systemPackages = with pkgs; [
    clinfo
    nvtopPackages.full
    tuxclocker-without-unfree
    tuxclocker-plugins-with-unfree
  ];

  # services.xserver.videoDrivers = ["nvidia" "amdgpu"];
}
