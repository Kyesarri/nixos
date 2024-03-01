{...}: {
  spaghetti = {
    user = "kel"; # single user currently, import attribute as spaghetti use ${spaghetti.user}
    user2 = "wombat";
    plymouth = "deus_ex"; # as above, use ${spaghetti.plymouth}
    system = "x86_64-linux"; # i dont use any other arch atm
  };
}
/*
wet noodles

planning to see if I can import this into flake.nix and pass-through to other modules

will really add more spaghetti to the config, thanks magic wizard linux people
*/

