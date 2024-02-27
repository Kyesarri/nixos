{
  description = "spaghetti nixos by kye";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    agenix.url = "github:ryantm/agenix";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:kyesarri/nix-colors";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    ags.url = "github:Aylur/ags";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master"; # added master branch to follow unstable nixos
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    alejandra,
    nix-colors,
    agenix,
    auto-cpufreq,
    ...
  } @ inputs: let
    #
    # pretty basic tings, passed through to the below nixosConfigurations
    #
    plymouth_theme = "deus_ex"; # passed into hosts/hostname/default.nix, requires plymouth_theme in tree
    system = "x86_64-linux"; # i dont use any other arch atm
    user = "kel"; # using single user in each system currently
    # ^
    # ^ could be easily expanded to other users on diff machines, moving this from here, to specialArgs
    # ^ example: specialArgs = { inherit foo bar; user = "kel"; };
    # ^ if inherit specialArgs, not tested but call again using specialArgs = { user = "kel"; }; maybe? nope!
    # ^ can't call twice :)
    #
    # interesting below is evaluated past the - in { - guess this is to be expected, we're just passsing
    # a string?
    #
    specialArgs = {inherit nix-colors auto-cpufreq inputs user plymouth_theme;};
    # ^
    # ^ the specialArgs is pretty loose and a cover-all, not all systems require every input
    # ^ want to find out how i can include other inherit in each machine
    # the above are added to the below by calling inherit foo
    # example:
    /*
    nixosConfigurations = {
    "host" = nixpkgs.lib.nixosSystem {
      inherit foo;
      ...
    };
    */
    #
    # good way to cut-down on boilerplate / reused code, but these comments are another thing
    #
    # imports = [./foo.nix]; # wondering if i can pass multiple atributes / fun tings
    # by importing, maybe just adding ./foo.nix? not tested either :)
  in {
    nixosConfigurations = {
      "nix-laptop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/laptop # 4800hs / 1650 / 16gb TODO download more ram
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];} # codium plugins
          home-manager.nixosModules.home-manager
          auto-cpufreq.nixosModules.default
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-notebook" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/notebook # celeron N3050 / i"gpu" / 4gb?
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-desktop" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/desktop # msi-z790i edge wifi / 13900kf / 3070 / 32gb
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit nix-colors inputs;};
            };
          }
        ];
      };
      "nix-serv" = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/serv # 15s-fq2050TU / i5-1135G7 / iris x / 8gb FIXME
          {environment.systemPackages = [alejandra.defaultPackage.x86_64-linux];}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
