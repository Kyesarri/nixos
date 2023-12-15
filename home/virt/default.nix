# ./home/virt/default.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.kel.extraGroups = ["vboxusers"];
  users.users.kel.packages = with pkgs; [
    virt-manager # TODO might need some nix added to configure using qemu as default for OOBE
    qemu # this needed with virtmanager? TODO i believe so
    libvirt
  ];
  virtualisation.spiceUSBRedirection.enable = true; # usb passthrough to vm
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
# ./home/virt/default.nix

