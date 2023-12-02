{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
      user.name = "kye";
      user.email = "kyesarri@gmail.com"; # hello internet :D
    };
  };
}
