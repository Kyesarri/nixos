{config, ...}: {
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "enp1s0"; # moving to m.2 ethernet "soon"
    # Lazy IPv6 connectivity for the container # do i want ipv6? :)
    enableIPv6 = false;
  };
  imports = [
    ./nextcloud
  ];
}
