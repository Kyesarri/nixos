{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/lite-xl/colors/nix.lua" = {
    # add nix-colors to litexl config
    text = ''
      local style = require "core.style"
      local common = require "core.common"

      style.background = { common.color "#${config.colorscheme.palette.base00}" }
      style.background2 = { common.color "#${config.colorscheme.palette.base01}" }
      style.background3 = { common.color "#${config.colorscheme.palette.base02}" }
      style.text = { common.color "#${config.colorscheme.palette.base05}" }
      style.caret = { common.color "#${config.colorscheme.palette.base06}" }
      style.accent = { common.color "#${config.colorscheme.palette.base0A}" } -- Text in autocomplete and command, col(>80) in satusbar
      style.dim = { common.color "#${config.colorscheme.palette.base03}" } -- Text of nonactive tabs, prefix in log
      style.divider = { common.color "#${config.colorscheme.palette.base01}" }
      style.selection = { common.color "#${config.colorscheme.palette.base03}" }
      style.line_number = { common.color "#${config.colorscheme.palette.base03}" }
      style.line_number2 = { common.color "#${config.colorscheme.palette.base03}" } -- Number on line with caret
      style.line_highlight = { common.color "#${config.colorscheme.palette.base00}"}
      style.scrollbar = { common.color "#${config.colorscheme.palette.base03}" }
      style.scrollbar2 = { common.color "#${config.colorscheme.palette.base04}" } -- Hovered

      style.syntax["normal"] = { common.color "#${config.colorscheme.palette.base0D}" }
      style.syntax["symbol"] = { common.color "#${config.colorscheme.palette.base08}" }
      style.syntax["comment"] = { common.color "#${config.colorscheme.palette.base03}" }
      style.syntax["keyword"] = { common.color "#${config.colorscheme.palette.base0E}" }  -- local function end, if case
      style.syntax["keyword2"] = { common.color "#${config.colorscheme.palette.base06}" } -- was 0b
      style.syntax["number"] = { common.color "#${config.colorscheme.palette.base0F}" }
      style.syntax["literal"] = { common.color "#${config.colorscheme.palette.base0C}" }
      style.syntax["string"] = { common.color "#${config.colorscheme.palette.base0B}" } -- was 0b
      style.syntax["operator"] = { common.color "#${config.colorscheme.palette.base0D}"}  -- = + - / < >
      style.syntax["function"] = { common.color "#${config.colorscheme.palette.base08}" }

      -- PLUGINS
      style.linter_warning = { common.color "#${config.colorscheme.palette.base0F}" }     -- linter
      style.bracketmatch_color = { common.color "#${config.colorscheme.palette.base03}" } -- bracketmatch
      style.guide = { common.color "#${config.colorscheme.palette.base00}" }
      style.guide_highlight = { common.color "#${config.colorscheme.palette.base03}" }              -- indentguide
      style.guide_width = 1                                 -- indentguide
    '';
  };
}
