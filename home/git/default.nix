{
  pkgs,
  spaghetti,
  secrets,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.git-crypt];

  home-manager.users.${spaghetti.user}.programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
      user.name = "kye";
      user.email = "${secrets.email.main}"; # bye internet :D
    };
  };
}
