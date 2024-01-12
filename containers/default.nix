{config, ...}: {
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "wlan0"; # moving to m.2 ethernet "soon"
    # Lazy IPv6 connectivity for the container # do i want ipv6? :)
    enableIPv6 = true;
  };
  imports = [
    ./nextcloud
  ];
}
