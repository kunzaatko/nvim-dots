local components = require(HEIRLINE_CONFIG_HOME .. '.components')
local utils = require(HEIRLINE_CONFIG_HOME .. '.utils')
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
  condition = function()
    return conditions.buffer_matches { filetype = { 'NvimTree' } }
  end,

  hl = {
    fg = 'base_darkblue',
    bg = 'base_bg',
  },

  components.TreeLeftBorderBlock,
  components.Align,
  components.TreeRightBorderBlock,
} --}}}

--- Tree unfocused buffer statusline
local TreeStatusLineInactive = { --{{{
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches { filetype = { 'NvimTree' } }
  end,
  hl = {
    fg = 'inactive_base_darkblue',
    bg = 'inactive_base_bg',
  },

  components.TreeLeftBorderBlock,
  components.Align,
  components.TreeRightBorderBlock,
} -- }}}

return { TreeStatusLineInactive, TreeStatuslineActive }
