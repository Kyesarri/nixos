# fino-time-mod.zsh-theme
# Otherwise, you can specify the color using the color code that
# is from 0–255 or use the hex code like %F{#FFBF00}.
# modded to follow nix-colors themes
# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
{
  config,
  inputs,
  outputs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file."/home/${user}/.config/omzsh/omzsh-nix.zsh-theme" = {
    text = ''
      function virtualenv_info {
          [ $CONDA_DEFAULT_ENV ] && echo "($CONDA_DEFAULT_ENV) "
          [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
      }

      function prompt_char {
          git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
          echo '○'
      }

      function box_name {
        local box="''${SHORT_HOST:-$HOST}"
        echo "''${box:gs/%/%%}"
      }

      PROMPT="╭─%F{#${config.colorscheme.palette.base0E}}%n%|%f%F{#${config.colorscheme.palette.base04}}%| on%f%F{#${config.colorscheme.palette.base0A}}%| $(box_name)%f%F{#${config.colorscheme.palette.base04}}%| in%f%F{#${config.colorscheme.palette.base0C}}%| %{$terminfo[bold]%}%~%f\$(git_prompt_info) %D - %*
      ╰─\$(virtualenv_info)\$(prompt_char) "

      ZSH_THEME_GIT_PROMPT_PREFIX=" %F{#${config.colorscheme.palette.base09}}%|git %f"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%F{#${config.colorscheme.palette.base0F}}%| ✘✘✘%f"
      ZSH_THEME_GIT_PROMPT_CLEAN="%F{#${config.colorscheme.palette.base0B}}%| ✔%f"
    '';
  };
}
