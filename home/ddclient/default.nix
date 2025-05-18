{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    usev4 = "ipv4";
    usev6 = "";
    zone = "galing.org";
    domains = ["galing.org" "chat.galing.org" "request.galing.org" "ztnet.galing.org"];
    username = "${secrets.email.main}";
    passwordFile = "/root/cloudflare"; # manually added
    interval = "1min";
  };
}
