{spaghetti, ...}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      # monitor = name, resolution(@hz *optional*), position, scale
      monitor = eDP-1, 1920x1080@120, auto, 1
      monitor = HDMI-A-1, 3840x1600, 0x0, 1

      # env = WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
      # gpu preference for hypr, set to prefer integrated but will use dedicated if integrated isnt available

      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      # hypr specific laptop things that will break tings
      # tings were ok... what a mad world
    '';
  };
}
