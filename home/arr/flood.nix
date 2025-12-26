# taken from https://discourse.nixos.org/t/permission-issue-when-attempting-to-use-an-alternate-webui-for-transmission/28745/3
# adds flood ui to transmission via overlays
{pkgs, ...}: let
  flood = pkgs.fetchzip {
    url = "https://github.com/johman10/flood-for-transmission/releases/download/latest/flood-for-transmission.zip";
    hash = "sha256-DRWD+0ArfNR1V44DLdnT5sv3+4MftTlvoyzJJ4jdcKI=";
  };
in {
  nixpkgs.overlays = [
    (self: super: {
      transmission = super.transmission.overrideAttrs (old: {
        postInstall =
          old.postInstall
          + ''
            cp -R ${flood} $out/share/transmission/web/flood
          '';
      });
    })
  ];

  systemd.services.transmission.environment.TRANSMISSION_WEB_HOME = "${pkgs.transmission_4}/share/transmission/web/flood";
}
# the other method mentioned in the thread was not working for me, the above works fine

