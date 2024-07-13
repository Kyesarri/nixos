{
  spaghetti,
  pkgs,
  ...
}: {
  # enable wl-screenrec
  users.users.${spaghetti.user}.packages = [pkgs.wl-screenrec];
  hardware.graphics.extraPackages = [pkgs.libva-utils pkgs.vaapiVdpau pkgs.nvidia-vaapi-driver];
  boot.initrd.kernelModules = ["amdgpu" "dm-snapshot"];
}
