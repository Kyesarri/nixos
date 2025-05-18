{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    use = "v4";
    usev4 = "webv4, webv4=ipv4.ident.me/";
    usev6 = "ifv6, ifv6=eth0";
    zone = "galing.org";
    domains = ["galing.org" "chat.galing.org" "request.galing.org" "ztnet.galing.org"];
    username = "${secrets.email.main}";
    passwordFile = "/root/cloudflare"; # manually added
    interval = "1min";
  };
}
