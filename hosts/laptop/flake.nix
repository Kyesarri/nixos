{
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
}
