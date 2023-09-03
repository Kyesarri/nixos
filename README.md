# nixos
![spagh](https://img.shields.io/badge/made_with-spaghetti-blue) ![adhd](https://img.shields.io/badge/and%20adhd-b7f7bf)
> my public spaghetti nixos
> 
> system specific .nix for laptop ga401 / desktop

## issues:

not booting correctly from fresh install - need to move much more out of configuration.nix and into their own builds

maybe package all tweaks into their own nix and declare from nix-#system.nix 

idea behind this git is really a dumping ground for my own .nix, in case anything is broken in a future bowl of spaghetti; i can always rebuild from these

these .nix are specific to my hardware cconfigurations and may not work on your own system, feel free to use but YMMV

## whats included:

- kde + themes
- lightdm
- xanmod kernel
- tailscale with tray icon
- steam
- zsh + ohmyzsh
- smartd drive monitoring via notifications
- kitty terminal