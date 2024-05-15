{...}: {
  # must be a better way to structure this, not a fan of
  # so much boiler-plate for each container :D
  imports = [
    ./radarr.nix
    ./sonarr.nix
    ./bazarr.nix
    ./proxarr.nix
    ./prowlarr.nix
    ./readarr.nix
  ];
}
