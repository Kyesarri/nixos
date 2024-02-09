{
  config,
  pkgs,
  user,
  ...
}: {
  hardware = {
    nvidia = {
      # nvidiaPersistenced = true; # ensures nv gpus stay awake
      modesetting.enable = true;
      # powerManagement.enable = true; # supposed to fix suspend issues
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };

  # users.users.${user}.packages = with pkgs; [nvtop];

  environment.systemPackages = with pkgs; [
    clinfo
    gwe
    nvtop-nvidia
    virtualglLib
    vulkan-loader
    vulkan-tools
  ];

  services.xserver = {videoDrivers = ["nvidia"];};
}
