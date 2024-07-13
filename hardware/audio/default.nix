{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/audio.conf" = {
    text = ''
      windowrule = float, ^(pavucontrol)$
    '';
  };
  users.users.${spaghetti.user}.packages = with pkgs; [pamixer pavucontrol];
  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # will need to break this out to pipewire and / or av covering both audio and visual aspects of pipewire
  };
}
