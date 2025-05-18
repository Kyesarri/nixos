{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "galing.org";
    usev4 = "webv4, webv4=ipv4.ident.me/";
    usev6 = "";
    domains = ["galing.org" "chat.galing.org" "request.galing.org" "ztnet.galing.org"];
    # username = "${secrets.email.main}";
    passwordFile = "/root/cloudflare"; # manually added
    interval = "5min";
    verbose = true;
  };
}
