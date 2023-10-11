# adapted from https://github.com/jsw08/dots/blob/master/modules/jsw_home/wofi/wofi/style.css
{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.programs.wofi = {
    enable = true;
    settings = {
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = false;
      print_command = true;
      insensitive = true;
    };
        style = {
          window = {
            margin = "5px";
            background-color = "#282828";
            opacity = "0.9";
            border-radius = "5px";
          };

          outer-box = {
            margin = "5px";
            border-radius = "5px";
          };

          input = {
            margin = "5px";
            background-color = "#504945";
            color = "#f8f8f2";
            font-size = "18px";
            border = "0";
            border-radius = "5px";
          };

          inner-box = {
            background-color = "#3c3836";
            border-radius = "5px";
          };

          scroll = {
            font-size = "16px";
            color = "#f8f8f2";
            margin = "5px";
            border-radius = "5px";
          };

          scroll_label = {
            margin = "2px 0px";
          };

          entry = {
            margin = "5px";
            background-color = "#665c54";
            border-radius = "5px";
          };
          entry_selected = {
            background-color = "#928374";
            border = "2px solid #a89984";
          };

          img {
            margin = "5px";
            border-radius = "5px";
          };

          text = {
            margin = "5px";
            border = "none";
            color = "#ebdbb2";
      };
    };
  }
}
