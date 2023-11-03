{ lib, ... }: 
with lib; 
{ 
  options.variables = {  # options.<this> needs to be named correctly in other files; looks to work for home.nix now
    username = mkOption { # username here will be called with config.options.username;
      type = types.str; 
      default = "kel"; 
      description = "username"; 
    }; 
    homedir = mkOption {
      type = types.str; 
      default = "/home/kel"; 
      description = "homedir"; 
    }; 
  }; 
}
