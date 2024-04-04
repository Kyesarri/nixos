let
  username = "ssh-foo bar";
  users = [username];
in {
  "key.age".publicKeys = [username];
}
