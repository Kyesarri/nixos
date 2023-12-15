{
  # imports = [./kdeconnect.nix];

  home-manager.users.kel.home.file.".config/hypr/per-app/gaming.conf" = {
    text = ''
    '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
    dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
  };

  services.ratbagd.enable = true;

  users.users.kel.packages = with pkgs; [
    pcsx2 # ps2 emulator
    piper # frontend for libratbag added in services
    protonup-qt # proton-ge # TODO get working with steam
  ];
}
