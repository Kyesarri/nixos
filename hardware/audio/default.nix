{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = with pkgs; [
    pamixer # cli
    pavucontrol # gui
  ];

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # hyprland specific config - for floating window rule
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/audio.conf" = {
    text = ''
      windowrule = float, ^(org.pulseaudio.pavucontrol)$
    '';
  };
}
