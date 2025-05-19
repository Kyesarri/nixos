/*
ddclient updates dynamic DNS entries for accounts on a wide range of dynamic DNS services.

This is applicable to a wide range of use cases. It’s commonly used when you have an IP address that changes regularly
(e.g. on a residential network), that you want to keep service pointing at (e.g. your domain name).
*/
{secrets, ...}: {
  services.ddclient = {
    enable = true;
    protocol = "cloudflare";
    zone = "galing.org";
    usev4 = "webv4, webv4=ipv4.ident.me/";
    usev6 = "";
    domains = ["galing.org"];
    # username = "${secrets.email.main}"; # disabling this will throw errors, however works fine!
    passwordFile = "/root/cloudflare"; # manually added
    interval = "5min";
    verbose = true;
  };
}
