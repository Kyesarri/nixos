{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  environment.systemPackages = with pkgs; [nebula];
  services.nebula.networks.mesh = {
    enable = true;
    isLighthouse = false;
  };
}
