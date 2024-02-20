# fino-time-mod.zsh-theme
# Otherwise, you can specify the color using the color code that
# is from 0–255 or use the hex code like %F{#FFBF00}.
# modded to follow nix-colors themes
# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/
# ${config.colorscheme.palette.base00}
{
  config,
  inputs,
  outputs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file."/home/${user}/.config/omzsh-nix.zsh-theme" = {
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
        [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
        echo "''${box:gs/%/%%}"
      }

      PROMPT="╭─%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info)\$(ruby_prompt_info) %D - %*
      ╰─\$(virtualenv_info)\$(prompt_char) "

      ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
      ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
      ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
    '';
  };
}
