# ./hardware/sound.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  security.rtkit.enable = true; # not required but added anyway for some reason
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
# ./hardware/sound.nix

