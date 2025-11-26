local components = require(HEIRLINE_CONFIG_HOME .. '.components')
local utils = require(HEIRLINE_CONFIG_HOME .. '.utils')
local conditions = require 'heirline.conditions'

components.TerminalName = { --{{{
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', ''):gsub(';.*', '')
    return '  ' .. tname --  ,  , 
  end,
} --}}}

--- Left border terminal component block █  fish ⟫
components.TerminalLeftBorderBlock = { --{{{
  components.BlockBar,
  components.Space,
  components.TerminalName,
  components.Space,
  { provider = '⟩' },
} --}}}

-- TODO: Add some additional components for terminal specific functionality <kunzaatko martinkunz@email.cz>
--- Right border terminal component block ⟪ 150:9  30% ▃
components.TerminalRightBorderBlock = { --{{{
  { provider = '⟨' },
  components.Space,
  components.BlockBar,
} --}}}

--- Terminal focused buffer statusline
local TerminalStatuslineActive = { --{{{
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,

  hl = {
    fg = 'base_yellow',
    bg = 'base_bg',
  },

  components.TerminalLeftBorderBlock,
  components.Align,
  components.Timer,
  components.Align,
  components.TerminalRightBorderBlock,
} --}}}

--- Terminal unfocused buffer statusline
local TerminalStatusLineInactive = { --{{{
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches { buftype = { 'terminal' } }
  end,
  hl = {
    fg = 'inactive_base_yellow',
    bg = 'inactive_base_bg',
  },

  components.TerminalLeftBorderBlock,
  components.Align,
  components.TerminalRightBorderBlock,
} -- }}}

return { TerminalStatusLineInactive, TerminalStatuslineActive }
