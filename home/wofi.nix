#  css adapted from https://github.com/jsw08/dots/blob/master/modules/jsw_home/wofi/wofi/style.css
{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."dots/config/wofi/style.css" = {
    text = ''
      window {
        margin: 5px;
        background-color: #${config.colorScheme.colors.base00};
        opacity: 1.0;
        font-size: 15px;
        font-family: JetBrainsMonoNL NF;
        border-radius: 10px;
        border: 5px solid #${config.colorScheme.colors.base03};
      }

      #outer-box {
        margin: 5px;
        border: 5;
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        background-color: #${config.colorScheme.colors.base01};
        color: #${config.colorScheme.colors.base05};
        font-size: 15px;
        border: 5px;
        border-radius: 10px;
      }

      #inner-box {
        background-color: #${config.colorScheme.colors.base00};
        border: 5;
        border-radius: 10px;
      }

      #scroll {
        font-size: 15px;
        color: #${config.colorScheme.colors.base0F};
        margin: 10px;
        border-radius: 5px;
      }

      #scroll label {
        margin: 0px 0px;
      }

      #entry {
        margin: 5px;
        background-color: #${config.colorScheme.colors.base01};
        border-radius: 10px;
        border: 5;
      }
      #entry:selected {
        background-color: #${config.colorScheme.colors.base02};
        border: 5px solid #${config.colorScheme.colors.base03};
        border-radius: 10px;
        border: 5;
      }

      #img {
        margin: 5px;
        border-radius: 5px;
      }

      #text {
        margin: 2px;
        border: none;
        color: #${config.colorScheme.colors.base05};
      }
    '';
  };
  home-manager.users.kel.programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      height = 300;
      always_parse_args = true;
      show_all = false;
      print_command = true;
      insensitive = true;
    };
  };
}
