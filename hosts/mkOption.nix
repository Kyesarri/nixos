# brain spaghetti around mkOption, file not to be imported
{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib; let
  cfg = config.services.ags;
in {
  options.services.ags = {
    enable = mkEnableOption "enable ags shell"; # will be services.ags.enable = true; in host.nix
    greeter = mkOption {
      # make an option for greeter
      type = types.str; # type, here string can be boolean or others...
      default = "world"; # set a sane default, or nothing if we want chaos
    };
  };

  # wonder if i can do an import /home/foo/ and define some paramater here, taking away from additional module config
  # do i push these options to each /home/foo/ and configure in the host after an import?
  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.ags.enable = true;
    };
  };
}
/*
from here i can enable a package, pass variables defined in the above options to
the package, not sure if this is something that should happen at the flake level
or can happen lower, i suppose this would be OK to do from the hosts/foo/default.nix
seems like however there is lots of my config that would be, a task to push to a
mkoption style of config
*/
#
# example below:
#
/*
with lib; let
cfg = config.services.hello; # shorthand
in {

options.services.hello = {
  enable = mkEnableOption "hello service"; # if enabled
  greeter = mkOption { # make an option for greeter
    type = types.str; # type, here string can be boolean or others...
    default = "world"; # set a sane default, or nothing if we want chaos
  };
};
}
*/
# above seems self explanitory after my comments
#
# below then checks if the mkIf option enable is true, if so it proceeds
# with our defined configuration as is seen below
/*
config = mkIf cfg.enable { # if enabled, make below happen

systemd.services.hello = { # standard nix jargon, create systemd service named hello

  wantedBy = ["multi-user.target"]; # linux magic man talk, whats the target service which will run this spell

  serviceConfig.ExecStart = "${pkgs.hello}/bin/hello -g'Hello, ${escapeShellArg cfg.greeter}!'";
  ^
  ^ configure the magic man service, execute package hello at start of target define where the binary
  ^ is hiding, add command -g nfi what that does, with content in quotes
  ^ 'escape shell arguments spell, write cfg.greeter option with an ! on the end'
};
*/
# lots to digest but the theory is, make a stack of options for each package, have nix mkOption
# define those said options and pass those to packages
# this might become one bigboi unless i can define some more globals, then pass those into
# their own smaller bois, but i guess that will add more boilerplate code in the host's
# default nix
# fun times
#
# import from hosts/foo/default.nix
/*
{
imports = [ ./hello.nix ];
...
services.hello = {
  enable = true;
  greeter = "Bob";
};
}
*/
# looking at the above snippits, we set a variable thats defined in another file, say our
# hosts/foo/default.nix
# we can then use that lower in the configuration settings for said file
# example cfg.greeter is config.services.hello.greeter, which would be Bob

