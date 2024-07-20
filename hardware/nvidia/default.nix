{
  config,
  pkgs,
  ...
}: {
  hardware = {
    nvidia = {
      # nvidiaPersistenced = true; # ensures nv gpus stay awake
      modesetting.enable = true;
      /*
        powerManagement = {
        enable = true;
        finegrained = true;
      };
      */
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  # users.users.${spaghetti.user}.packages = with pkgs; [nvtop];

  environment.systemPackages = with pkgs; [
    clinfo
    gwe # gpu overclocking
    nvtopPackages.full
  ];

  services.xserver.videoDrivers = ["nvidia"];
}
