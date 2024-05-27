# adds nix-colors palette to console / tuigreetd
# TODO review colours set here - currently looks to
# be using duplicates
{config, ...}: {
  console = {
    earlySetup = true;
    # font = "Hack-Regular";
    useXkbConfig = true; # same config for linux console
    colors = [
      # terminal8
      "${config.colorScheme.palette.base00}" # black
      "${config.colorScheme.palette.base08}" # red
      "${config.colorScheme.palette.base0B}" # green
      "${config.colorScheme.palette.base0A}" # yellow
      "${config.colorScheme.palette.base0D}" # blue
      "${config.colorScheme.palette.base0E}" # magenta
      "${config.colorScheme.palette.base0C}" # cyan
      "${config.colorScheme.palette.base05}" # white
      # terminal16
      "${config.colorScheme.palette.base02}" # bright black
      "${config.colorScheme.palette.base09}" # bright red
      "${config.colorScheme.palette.base06}" # bright green
      "${config.colorScheme.palette.base0F}" # bright yellow
      "${config.colorScheme.palette.base0D}" # bright blue
      "${config.colorScheme.palette.base0E}" # bright magenta
      "${config.colorScheme.palette.base0C}" # bright cyan
      "${config.colorScheme.palette.base07}" # bright white
    ];
  };
}
