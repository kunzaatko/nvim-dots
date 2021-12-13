local gl = require 'galaxyline'
local hsl = require 'lush.hsl'
local condition = require 'galaxyline.condition'
local gls = gl.section
local gps = require 'nvim-gps'

local providers = {
  buffer = require 'galaxyline.provider_buffer',
  file_info = require 'galaxyline.provider_fileinfo',
  diagnostic = require 'galaxyline.provider_diagnostic',
  vcs = require 'galaxyline.provider_vcs',
  lsp = require 'galaxyline.provider_lsp',
}

gl.short_line_list = {
  'startify',
  'undotree',
  'startuptime',
  'packer',
  'NeogitStatus',
  'octo',
  'help',
  'toggleterm',
}

local palette = { -- {{{
  nord0 = hsl(220, 16, 22), -- #2F3541
  nord1 = hsl(222, 16, 28), -- #3C4353
  nord2 = hsl(220, 17, 32), -- #444D5F
  nord3 = hsl(220, 16, 36), -- #4D576A
  nord3_bright = hsl(220, 17, 46), -- #616F89
  nord4 = hsl(219, 28, 88), -- #D8DEE9
  nord5 = hsl(218, 27, 92), -- #E5E9F0
  nord6 = hsl(218, 27, 94), -- #ECEFF4
  nord7 = hsl(179, 25, 65), -- #8FBCBB
  nord8 = hsl(193, 43, 67), -- #87BFCF
  nord9 = hsl(210, 34, 63), -- #81A1C1
  nord10 = hsl(213, 32, 52), -- #5D81AC
  nord11 = hsl(354, 42, 56), -- #BE6069
  nord12 = hsl(14, 51, 63), -- #D18771
  nord13 = hsl(40, 71, 73), -- #EBCA89
  nord14 = hsl(92, 28, 65), -- #A4BF8D
  nord15 = hsl(311, 20, 63), -- #B48EAD
} -- }}}

local colors = { -- {{{
  bg = palette.nord0.da(50).hex,
  blue = palette.nord9.hex,
  cyan = palette.nord8.hex,
  darkblue = palette.nord10.hex,
  fg = palette.nord4.hex,
  green = palette.nord14.hex,
  magenta = palette.nord15.hex,
  orange = palette.nord12.hex,
  red = palette.nord11.hex,
  violet = palette.nord15.da(10).hex,
  yellow = palette.nord13.hex,
} -- }}}

local mode_color = { -- {{{
  n = colors.red,
  i = colors.green,
  v = colors.blue,
  [''] = colors.blue,
  V = colors.blue,
  c = colors.magenta,
  no = colors.red,
  s = colors.orange,
  S = colors.orange,
  [''] = colors.orange,
  ic = colors.yellow,
  R = colors.violet,
  Rv = colors.violet,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red,
} -- }}}

-- NOTE: Set the statusline background <kunzaatko> --
local readonly_icon = " "
local modified_icon = " "

------------
--  Left  --
------------

gls.left[1] = { -- ModeBlockLeft -- ▊   ⟫ {{{
  ModeBlockLeft = {
    provider = function()
      vim.api.nvim_command(
        'hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg
      )
      local provider = function()
        local icons = { dos = '', mac = '', unix = ' ' }
        -- auto change color according the vim mode
        if icons[vim.bo.fileformat] then
          return icons[vim.bo.fileformat]
        else
          return ''
        end
      end
      return ('▊ ' .. provider() .. ' ⟫')
    end,
    separator_highlight = { 'NONE', colors.bg },
    separator = ' ',
    highlight = 'GalaxyViMode',
  },
} -- }}}
gls.left[2] = { -- FileInfo --  galaxyline.lua   {{{
  FileIcon = {
    provider = providers.file_info.get_file_icon,
    highlight = { providers.file_info.get_file_icon_color, colors.bg },
  },
  FileName = {
    provider = function()
      return providers.file_info.get_current_file_name(modified_icon, readonly_icon) ..
               '⟩ '
    end,
    condition = condition.buffer_not_empty,
    highlight = { colors.darkblue, colors.bg, 'bold' },

  },
} -- }}}
gls.left[3] = { --   gls   left[3]   nvimGPS   provider {{{
  nvimGPS = {
    provider = function()
      return gps.get_location()
    end,
    condition = function()
      -- TODO: Add condition when is too wide from readme <06-12-21, kunzaatko> --
      return gps.is_available() and condition.hide_in_width()
    end,
    highlight = { palette.nord3_bright.hex, colors.bg, 'italic' },
  },
} -- }}}

-------------
--  Right  --
-------------
-- LSP  {{{
gls.right[1] = { -- LeftLSPSep {{{
  LeftLSPSep = {
    provider = function()
      return '{ '
    end,
    -- TODO: Check if LSP attached <06-12-21, kunzaatko> --
    -- condition = condition.check_git_workspace,
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.fg, colors.bg },
  },
} -- }}}
gls.right[2] = { -- {{{
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = { colors.red, colors.bg },
  },
} -- }}}
gls.right[3] = { -- {{{
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = { colors.yellow, colors.bg },
  },
} -- }}}
gls.right[4] = { -- {{{
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = { colors.cyan, colors.bg },
  },
} -- }}}
gls.right[5] = { -- {{{
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = { colors.blue, colors.bg },
  },
} -- }}}
gls.right[6] = { -- {{{
  LSPProvider = {
    provider = function()
      return '  ' .. providers.lsp.get_lsp_client() .. ' '
    end,
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.violet, colors.bg, 'italic' },
  },
} -- }}}
gls.right[7] = { -- {{{
  RightLSPSep = {
    provider = function()
      return ' }'
    end,
    separator_highlight = { 'NONE', colors.bg },
    -- TODO: Check if LSP attached <06-12-21, kunzaatko> --
    -- condition = condition.check_git_workspace,
    highlight = { colors.fg, colors.bg },
  },
} -- }}}
-- }}}

-- TODO: Do not show when there are no modifications in unstaged <05-12-21, kunzaatko> --
-- Git {{{
gls.right[8] = { -- SepGitLeft {{{
  SepGitLeft = {
    provider = function()
      return '{'
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.fg, colors.bg },
  },
} -- }}}
gls.right[9] = { -- DiffAdd {{{
  DiffAdd = {
    provider = 'DiffAdd',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    condition = condition.hide_in_width,
    icon = '+',
    highlight = { colors.green, colors.bg, 'bold' },
  },
} -- }}}
gls.right[10] = { -- DiffModified {{{
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = '~',
    highlight = { colors.yellow, colors.bg, 'bold' },
  },
} -- }}}
gls.right[11] = { -- DiffRemove {{{
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '-',
    highlight = { colors.red, colors.bg, 'bold' },
  },
} -- }}}
gls.right[12] = { -- GitIcon {{{
  GitIcon = {
    provider = function()
      return '  ' .. providers.vcs.get_git_branch()
    end,
    separator = ' ',
    condition = condition.check_git_workspace,
    separator_highlight = { 'NONE', colors.bg },
    highlight = { colors.violet, colors.bg, 'italic' },
  },
} -- }}}
gls.right[13] = { -- SepGitRight {{{
  SepGitRight = {
    provider = function()
      return '}'
    end,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    condition = condition.check_git_workspace,
    highlight = { colors.fg, colors.bg },
  },
} -- }}}
-- }}}

gls.right[14] = { -- ModeSepRight {{{
  ModeSepRight = {
    provider = function()
      return '⟪'
    end,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = 'GalaxyViMode',
  },
} -- }}}

gls.right[15] = { -- RightPositionNumerical{{{
  RightPositionNumerical = {
    provider = function()
      return string.format('%s:%s ', vim.fn.line('.'), vim.fn.col('.'))
    end,
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = 'GalaxyViMode',
  },
} -- }}}

gls.right[16] = { -- LinePercent {{{
  LinePercent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = { 'NONE', colors.bg },
    highlight = 'GalaxyViMode',
  },
} -- }}}
gls.right[17] = { -- ModeBlockRight {{{
  ModeBlockRight = {
    provider = function()
      return '  ▊'
    end,
    highlight = 'GalaxyViMode',
  },
} -- }}}

-----------------------
--  Short Line Left  --
-----------------------

gls.short_line_left = {
  { -- BlockLeft {{{
    BlockLeft = {
      provider = function()
        vim.api.nvim_command(
          'hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' ..
            colors.bg
        )
        return '▊ ' .. providers.buffer.get_buffer_filetype() .. ' ⟫'
      end,
      highlight = 'GalaxyViMode',
    },
  }, -- }}}
}

gls.short_line_right = {
  { -- SFileName {{{
    SFileName = {
      provider = function()
        return '⟪ ' ..
                 providers.file_info.get_current_file_name(modified_icon, readonly_icon)
      end,
      condition = condition.buffer_not_empty,
      highlight = 'GalaxyViMode',
    },
  }, -- }}}
  { -- BufferIcon {{{
    BufferIcon = { provider = 'BufferIcon', highlight = { colors.fg, colors.bg } },
  }, -- }}}
  { -- BlockRight {{{
    BlockRight = {
      provider = function()
        return '  ▊'
      end,
      highlight = 'GalaxyViMode',
    },
  }, -- }}}
}
