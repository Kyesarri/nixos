# ssssh it's a secret
please see [example.secrets.json](/secrets.example/example.secrets.json) - many of my configs require secrets for ip / email addresses / passwords and so on

## warning
if using my configs / pushing to your own public git you will need to use git-crypt on your own secrets.json

without doing so, your secrets will be in plain-text for anyone and everyone to see, admittidly this isn't the most secure solution as secrets when unencrypted are readable by (all?) users of the system as they will reside in the nix-store.

i'm not a security expert, use at your own risk (as there are some with storing anything on someone elses computer)

if you don't trust keeping your secrets on a git, add secrets/secrets.json to your .gitignore