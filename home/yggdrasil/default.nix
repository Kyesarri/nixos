{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      # Peers = [
      #   "tls://213.226.68.79:32864"
      # ];
    };
  };
}
