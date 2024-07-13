{
  spaghetti,
  pkgs,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/gaming.conf" = {
    text = ''
      windowrule = fullscreen, title:Steam Big Picture Mode
      windowrule = float, title:Steam
    '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  services.ratbagd.enable = true; # mouse configuration tool

  users.users.${spaghetti.user}.packages = with pkgs; [
    shattered-pixel-dungeon
    # pcsx2 # ps2 emulator # TODO 22/01/24 has issues building, hash mismatch
    piper # frontend for libratbag
    protonup-qt # proton-ge # TODO get working with steam
    gamescope # wl roots gaming compositor, needs steam config not working currently
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
}
# By default, Steam looks for custom Proton versions such as GE-Proton in ~/.steam/root/compatibilitytools.d.
# Additionally the environment variable STEAM_EXTRA_COMPAT_TOOLS_PATHS can be set to change or add to the paths
# which steam searches for custom Proton versions.

