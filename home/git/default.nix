{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
      user.name = "kye";
      user.email = "kyesarri@gmail.com"; # hello internet :D
    };
  };
}
