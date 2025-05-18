{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "galing.org";
    domains = ["galing.org" "chat.galing.org" "request.galing.org" "ztnet.galing.org"];
    username = "${secrets.email.main}";
    passwordFile = "/root/cloudflare"; # manually added
    interval = "1min";
  };
}
