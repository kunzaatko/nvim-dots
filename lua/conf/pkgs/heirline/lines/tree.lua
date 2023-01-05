local components = require 'conf.pkgs.heirline.components'
local utils = require 'conf.pkgs.heirline.utils'
local conditions = require 'heirline.conditions'

--- ' '
components.TreeIcon = { --{{{
  provider = ' ',
} --}}}

--- Left border tree component block █  ⟫
components.TreeLeftBorderBlock = { --{{{
  components.BlockBar,
  components.Space,
  components.TreeIcon,
  components.Space,
  { provider = '⟩' },
} --}}}

--- Right border tree component block ⟪  █
components.TreeRightBorderBlock = { --{{{
  { provider = '⟨' },
  components.Space,
  components.BlockBar,
} --}}}

--- Tree focused buffer statusline
local TreeStatuslineActive = { --{{{
  static = {
    colors = utils.color_spec,
  },
  condition = function()
    return conditions.buffer_matches { filetype = { 'NvimTree' } }
  end,

  hl = function(self)
    return {
      fg = self.colors.base.darkblue,
      bg = self.colors.base.bg,
    }
  end,

  components.TreeLeftBorderBlock,
  components.Align,
  components.TreeRightBorderBlock,
} --}}}

--- Tree unfocused buffer statusline
local TreeStatusLineInactive = { --{{{
  static = {
    colors = utils.color_spec_inactive,
  },
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches { filetype = { 'NvimTree' } }
  end,
  hl = function(self)
    return {
      fg = self.colors.base.darkblue,
      bg = self.colors.base.bg,
    }
  end,

  components.TreeLeftBorderBlock,
  components.Align,
  components.TreeRightBorderBlock,
} -- }}}

return { TreeStatusLineInactive, TreeStatuslineActive }
