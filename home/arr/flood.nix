{pkgs, ...}: let
  flood = pkgs.fetchzip {
    url = "https://github.com/johman10/flood-for-transmission/releases/download/2023-04-18T18-03-53/flood-for-transmission.zip";
    hash = "sha256-alsHOTF8EEF7iUNHvLC21V3VRVoYQSs78g2r7YGTDeQ=";
  };
in {
  nixpkgs.overlays = [
    (self: super: {
      transmission = super.transmission.overrideAttrs (old: {
        postInstall =
          old.postInstall
          + ''
            rm -rf $out/share/transmission/web
            cp -R ${flood} $out/share/transmission/web/flood
          '';
      });
    })
  ];
}
