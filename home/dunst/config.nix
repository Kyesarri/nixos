{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."/.config/dunst/dunstrc" = {
    text = ''
      [global]
      font="Hasklug Nerd Font Regular 9"
      frame_color="#${config.colorscheme.colors.base03}"
      height=300
      icon_path="/run/current-system/sw/share/icons/hicolor/32x32/actions:/run/current-system/sw/share/icons/hicolor/32x32/animations:/run/current-system/sw/share/icons/hicolor/32x32/apps:/run/current-system/sw/share/icons/hicolor/32x32/categories:/run/current-system/sw/share/icons/hicolor/32x32/devices:/run/current-system/sw/share/icons/hicolor/32x32/emblems:/run/current-system/sw/share/icons/hicolor/32x32/emotes:/run/current-system/sw/share/icons/hicolor/32x32/filesystem:/run/current-system/sw/share/icons/hicolor/32x32/intl:/run/current-system/sw/share/icons/hicolor/32x32/legacy:/run/current-system/sw/share/icons/hicolor/32x32/mimetypes:/run/current-system/sw/share/icons/hicolor/32x32/places:/run/current-system/sw/share/icons/hicolor/32x32/status:/run/current-system/sw/share/icons/hicolor/32x32/stock:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/actions:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/animations:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/apps:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/categories:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/devices:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/emblems:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/emotes:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/filesystem:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/intl:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/legacy:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/mimetypes:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/places:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/status:/etc/profiles/per-user/kel/share/icons/hicolor/32x32/stock:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/actions:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/animations:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/apps:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/categories:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/devices:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/emblems:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/emotes:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/filesystem:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/intl:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/legacy:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/mimetypes:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/places:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/status:/nix/store/dn214ysx5ixpj0wwjjscn6a3kgwhbrw2-hicolor-icon-theme-0.17/share/icons/hicolor/32x32/stock"
      offset="30x50"
      origin="top-center"
      transparency=10
      width=300
      corner_radius=10
      frame_width=5

      [urgency_normal]
      background="#${config.colorscheme.colors.base00}"
      foreground="#${config.colorscheme.colors.base05}"
      timeout=5

    '';
  };
}
