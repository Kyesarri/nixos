{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "galing.org";
    usev4 = "webv4, webv4=ipv4.ident.me/";
    domains = ["galing.org" "chat.galing.org" "request.galing.org" "ztnet.galing.org"];
    username = "${secrets.email.main}";
    passwordFile = "/root/cloudflare"; # manually added
    interval = "1min";
  };
}
