local conditions = require 'heirline.conditions'
local components = require(HEIRLINE_CONFIG_HOME .. '.components')

--- Normal focused buffer statusline
local StatusLineActive = { --{{{
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_colors = {
      n = 'base_red',
      i = 'base_yellow',
      v = 'base_blue',
      [''] = 'base_blue',
      V = 'base_blue',
      c = 'base_magenta',
      no = 'base_red',
      s = 'base_orange',
      S = 'base_orange',
      [''] = 'base_orange',
      ic = 'base_yellow',
      R = 'base_purple',
      Rv = 'base_purple',
      cv = 'base_red',
      ce = 'base_red',
      r = 'base_cyan',
      rm = 'base_cyan',
      ['r?'] = 'base_cyan',
      ['!'] = 'base_red',
      t = 'base_red',
    },
  },
  hl = {
    fg = 'base_fg',
    bg = 'base_bg',
  },
  components.LeftBorderBlockModeColored,
  components.Space,
  components.FileNameBlock,
  components.Space,
  -- components.Space,
  components.Align,
  components.Timer,
  components.Doing,
  -- components.Gps,
  components.Align,
  -- components.Space,
  -- components.Snippets,
  -- components.Space,
  components.AI,
  components.Space,
  components.LSPActive,
  components.Space,
  components.Diagnostics,
  components.Space,
  components.Git,
  components.Space,
  components.RightBorderModeColored,
} --}}}

--- Normal unfocused buffer statusline
local StatusLineInactive = { --{{{
  hl = {
    fg = 'inactive_base_fg',
    bg = 'inactive_base_bg',
  },
  condition = function()
    return not conditions.is_active()
  end,
  components.LeftBorderBlock,
  components.Space,
  components.FileNameBlock,
  components.Align,
  -- components.Gps,
  components.Align,
  components.Diagnostics,
  components.Space,
  components.Git,
  components.Space,
  components.RightBorderBlock,
} --}}}

return { StatusLineInactive, StatusLineActive }
