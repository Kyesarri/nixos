# TODO ./hardware/audio merge
{
  config,
  pkgs,
  lib,
  ...
}: {
  security.rtkit.enable = true; # not required but added anyway
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
