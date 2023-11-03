{ lib, ... }: 
with lib; 
{ 
  options.mymodule = { 
    var1 = mkOption { 
      type = types.str; 
      default = "something"; 
      description = "...."; 
    }; 
  }; 
}
