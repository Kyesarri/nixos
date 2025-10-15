{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user} = {
    extraGroups = ["vboxusers" "libvirtd"];
    packages = with pkgs; [
      libvirt
      gnome-boxes
    ];
  };

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true; # usb passthrough to vm
  virtualisation.libvirtd.enable = true;
  users.groups.libvirtd.members = ["${spaghetti.user}"];

  boot = {
    # add extra config for intel systems
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
