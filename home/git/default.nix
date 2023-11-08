{ config, pkgs, ... }: {
home-manager.users.kel.programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
    };
  }; 
}
