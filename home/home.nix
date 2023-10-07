# ./home/home.nix
# TODO move wofi / kitty / mako / waybar to their own nix
{
home-manager.useUserPackages = true;    # install packages to /etc/profiles instead of ~/.nix-profile
home-manager.useGlobalPkgs = true;      # this saves an extra Nixpkgs evaluation, adds consistency,
					# and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.users.kel =
  { pkgs, config, inputs, outputs, ... }:
  {
    imports =
    [
      inputs.nix-colors.homeManagerModules.default
    ];

    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    programs.home-manager.enable = true;
    home.stateVersion = "23.05";
    services.mako.enable = true; # TODO notification service, needs more work, just using OOBE currently
    home.packages = with pkgs; [  ];

    programs.git =
    {
      enable = true;
      extraConfig =
      {
        credential.helper = "libsecret";
      };
    };

    programs.wofi = # TODO wofi needs more options defined and configured, colours and appearance
    {
      enable = true;
      settings =
      {
        width=750;
        height=400;
        always_parse_args=true;
        show_all=false;
        print_command=true;
        insensitive=true;
      };
    };
  };
}
# ./home/home.nix
