local conditions = require 'heirline.conditions'
local components = require(HEIRLINE_CONFIG_HOME .. '.components')
local utils = require(HEIRLINE_CONFIG_HOME .. '.utils')

--- Normal focused buffer statusline
local StatusLineActive = { --{{{
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_colors = utils.mode_colors,
    colors = utils.color_spec,
  },
  hl = function(self)
    return {
      fg = self.colors.base.fg,
      bg = self.colors.base.bg,
    }
  end,
  components.LeftBorderBlockModeColored,
  components.Space,
  components.FileNameBlock,
  components.Space,
  components.Codeium,
  -- components.Space,
  components.Align,
  components.Timer,
  -- components.Gps,
  components.Align,
  -- FIX: This does not work <16-01-22, kunzaatko> --
  -- components.LSPMessages,
  -- components.Space,
  -- components.Snippets,
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
  static = {
    colors = utils.color_spec_inactive,
  },
  hl = function(self)
    return {
      fg = self.colors.base.fg,
      bg = self.colors.base.bg,
    }
  end,
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
