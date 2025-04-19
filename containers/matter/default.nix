{
  secrets,
  lib,
  ...
}: let
  contName = "matter";

  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.

}
