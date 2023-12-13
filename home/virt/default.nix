# ./home/virt/default.nix
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  users.users.kel.packages = with pkgs; [
    virt-manager
    qemu # this needed with virtmanager? TODO
  ];
  virtualisation.spiceUSBRedirection.enable = true;
  boot = {
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
# ./home/virt/default.nix

