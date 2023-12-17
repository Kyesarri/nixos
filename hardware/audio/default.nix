{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.home.file.".config/hypr/per-app/audio.conf" = {
    text = ''
      windowrule = float, ^(pavucontrol)$
    '';
  };
  users.users.kel.packages = with pkgs; [pamixer pavucontrol];
  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
