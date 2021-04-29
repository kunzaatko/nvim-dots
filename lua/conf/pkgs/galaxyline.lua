local gl = require 'galaxyline'
local hsl = require('lush').hsl
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {
  'startify',
  'undotree',
  'fugitive',
  'fugitiveblame',
  'startuptime',
  'NvimTree',
  'vista',
  'dbui',
  'packer',
}

local clrs = {
  nord0 = hsl(220, 16, 22),
  nord1 = hsl(222, 16, 28),
  nord2 = hsl(220, 17, 32),
  nord3 = hsl(220, 16, 36),
  nord3_bright = hsl(220, 17, 46),
  nord4 = hsl(219, 28, 88),
  nord5 = hsl(218, 27, 92),
  nord6 = hsl(218, 27, 94),
  nord7 = hsl(179, 25, 65),
  nord8 = hsl(193, 43, 67),
  nord9 = hsl(210, 34, 63),
  nord10 = hsl(213, 32, 52),
  nord11 = hsl(354, 42, 56),
  nord12 = hsl(14, 51, 63),
  nord13 = hsl(40, 71, 73),
  nord14 = hsl(92, 28, 65),
  nord15 = hsl(311, 20, 63),
}

local colors = {
  bg = clrs.nord0.da(10).hex,
  blue = clrs.nord9.hex,
  cyan = clrs.nord8.hex,
  darkblue = clrs.nord10.hex,
  fg = clrs.nord4.hex,
  green = clrs.nord14.hex,
  magenta = clrs.nord15.hex,
  orange = clrs.nord12.hex,
  red = clrs.nord11.hex,
  violet = clrs.nord15.da(10).hex,
  yellow = clrs.nord13.hex,
}

local mode_color = {
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
}

gls.left[1] = {
  RainbowRed = {
    provider = function()
      return '▊ '
    end,
    highlight = 'GalaxyViMode',
  },
}

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = {colors.red, colors.bg, 'bold'},
  },
}
gls.left[3] = {
  FileSize = {
    provider = 'FileSize',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg, colors.bg},
  },

}
gls.left[4] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
  },
}

gls.left[5] = {
  FileName = {
    provider = {'FileName'},
    condition = condition.buffer_not_empty,
    highlight = {colors.darkblue, colors.bg, 'bold'},
  },
}

gls.left[6] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.fg, colors.bg},
  },
}

gls.left[7] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.fg, colors.bg, 'bold'},
  },
}

gls.left[8] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red, colors.bg},
  },
}
gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow, colors.bg},
  },
}

gls.left[10] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan, colors.bg},
  },
}

gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue, colors.bg},
  },
}

gls.right[1] = {
  FileEncode = {
    provider = 'FileEncode',
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.green, colors.bg, 'bold'},
  },
}

gls.right[2] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.green, colors.bg, 'bold'},
  },
}

gls.right[3] = {
  GitIcon = {
    provider = function()
      return '  '
    end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.violet, colors.bg, 'bold'},
  },
}

gls.right[4] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet, colors.bg, 'bold'},
  },
}

-- FIXME: Add whitespace separator here <28-04-21, kunzaatko> --

gls.right[5] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green, colors.bg},
  },
}
gls.right[6] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange, colors.bg},
  },
}
gls.right[7] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red, colors.bg},
  },
}

gls.right[8] = {
  LeftBlock = {
    provider = function()
      return ' ▊'
    end,
    highlight = 'GalaxyViMode',
  },
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
    highlight = {colors.blue, colors.bg, 'bold'},
  },
}

gls.short_line_left[2] = {
  SFileName = {
    provider = 'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.fg, colors.bg, 'bold'},
  },
}

gls.short_line_right[1] = {
  BufferIcon = {provider = 'BufferIcon', highlight = {colors.fg, colors.bg}},
}
