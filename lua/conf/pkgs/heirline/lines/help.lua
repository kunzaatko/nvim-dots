local components = require 'conf.pkgs.heirline.components'
local utils = require 'conf.pkgs.heirline.utils'
local conditions = require 'heirline.conditions'

components.HelpFileName = { --{{{
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ':t')
  end,
} --}}}

--- Left border help component block ▃  bufferline.txt ⟫
components.HelpLeftBorderBlock = { --{{{
  components.ScrollBar,
  components.Space,
  { provider = '' },
  components.Space,
  components.HelpFileName,
  components.Space,
  { provider = '⟩' },
} --}}}

--- Right border help component block ⟪ 150:9  30% ▃
components.HelpRightBorderBlock = { --{{{

  { provider = '⟨' },
  components.Space,
  components.ShortRuler,
  components.Space,
  components.ScrollBar,
} --}}}

local HelpStatuslineActive = { --{{{
  static = {
    colors = utils.color_spec,
  },
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'help' },
    }
  end,
  hl = function(self)
    return {
      fg = self.colors.base.darkblue,
      bg = self.colors.base.bg,
    }
  end,

  components.HelpLeftBorderBlock,
  components.Align,
  components.HelpRightBorderBlock,
} --}}}

local HelpStatuslineInactive = { --{{{
  static = {
    colors = utils.color_spec_inactive,
  },
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches {
      buftype = { 'help' },
    }
  end,
  hl = function(self)
    return {
      fg = self.colors.base.darkblue,
      bg = self.colors.base.bg,
    }
  end,

  components.HelpLeftBorderBlock,
  components.Align,
  components.HelpRightBorderBlock,
} --}}}

return { HelpStatuslineInactive, HelpStatuslineActive }
