-- TODO: Document function and components <16-01-22, kunzaatko> --
local utils = require 'heirline.utils'
local hsl = require 'lush.hsl'
local conditions = require 'heirline.conditions'
local api = vim.api

-- TODO: Make a more flexible scheme of manipulating colours between different status lines. Split the colour spec
-- definitions into different parts and have their colours change differently... (for ex. {bg, fg}, and {colours})
-- <16-01-22, kunzaatko> --

--- Nord palette in hsl colour definitions
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

--- Colour definitions (hsl values)
local colors = { --{{{
  bg = palette.nord0.da(50), -- #181B21
  fg = palette.nord4, -- #D8DEE9

  red = palette.nord11, -- #BE6069
  magenta = palette.nord15, -- #B48EAD
  green = palette.nord14, -- #A4BF8D
  blue = palette.nord9, -- #81A1C1
  darkblue = palette.nord10, -- #5D81AC
  yellow = palette.nord13, -- #EBCA89
  gray = hsl(utils.get_highlight('NonText').fg),
  orange = palette.nord12, -- #D18771
  purple = palette.nord15.da(10), -- #A77B9F
  cyan = palette.nord8, -- #87BFCF
} --}}}

--- Base colour specification in hsl format
utils.base_color_spec = { --{{{

  bg = colors.bg, -- #181B21
  fg = colors.fg, -- #D8DEE9

  red = colors.red, -- #BE6069
  magenta = colors.magenta, -- #B48EAD
  green = colors.green, -- #A4BF8D
  blue = colors.blue, -- #81A1C1
  darkblue = colors.darkblue, -- #5D81AC
  yellow = colors.yellow, -- #EBCA89
  gray = colors.gray,
  orange = colors.orange, -- #D18771
  purple = colors.purple, -- #A77B9F
  cyan = colors.cyan, -- #87BFCF
  diag = {
    warn = hsl(utils.get_highlight('DiagnosticWarn').fg),
    error = hsl(utils.get_highlight('DiagnosticError').fg),
    hint = hsl(utils.get_highlight('DiagnosticHint').fg),
    info = hsl(utils.get_highlight('DiagnosticInfo').fg),
  },
  git = {
    del = hsl(utils.get_highlight('DiffDelete').fg),
    add = hsl(utils.get_highlight('DiffAdd').fg),
    change = hsl(utils.get_highlight('DiffChange').fg),
  },
} --}}}

--- Recursively map a table with hsl objects (for example `darken` all the values)
--- @param entry table
--- @param hsl_func function takes one hsl entry
--- @return table
utils.hsl_rec_map = function(entry, hsl_func) --{{{
  if vim.tbl_contains(vim.tbl_keys(getmetatable(entry) or {}), '__call') then -- is hsl object
    return hsl_func(entry)
  else
    return vim.tbl_map(function(i)
      return utils.hsl_rec_map(i, hsl_func)
    end, entry)
  end
end --}}}

--- hex the hsl colours and recurse into table layers
--- @param entry table
--- @return string hex colour
utils.hexify_color_spec = function(entry) --{{{
  return utils.hsl_rec_map(entry, function(hsl_entry)
    return hsl_entry.hex
  end)
end --}}}

--- Mode colour specification
utils.mode_colors = { --{{{
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
  R = colors.purple,
  Rv = colors.purple,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red,
} --}}}

--- Components of the statusbar
local components = {}

--- Single space
components.Space = { provider = ' ' }

--- Modifies the child components to have the modecolor highlight
components.ModeColorModifier = { --{{{
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    -- use `force` because we need to override the child's hl foreground
    return { fg = self.mode_colors[mode], force = true }
  end,
} --}}}

--- { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
components.ScrollBar = { --{{{
  static = {
    sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
  },
  provider = function(self)
    local curr_line = api.nvim_win_get_cursor(0)[1]
    local lines = api.nvim_buf_line_count(0)
    local i = math.floor(curr_line / lines * (#self.sbar - 1)) + 1
    return self.sbar[i]
    -- return string.rep(self.sbar[i], 2)
  end,
} --}}}

--- '█'
components.BlockBar = { --{{{
  provider = '█',
} --}}}

--- File-format icon for current buffer
---@return string {dos = '', mac = '', unix = ' '}/''
utils.get_file_format_icon = function() --{{{
  local icons = { dos = '', mac = '', unix = ' ' }
  if icons[vim.bo.fileformat] then
    return icons[vim.bo.fileformat]
  else
    return ''
  end
end --}}}

--- Icon of fileformat
components.FileFormatIcon = { --{{{
  static = {
    icon = utils.get_file_format_icon(),
  },
  provider = function(self)
    return self.icon
  end,
} --}}}

--- Left border component block ▃   ⟫
components.LeftBorderBlock = { --{{{
  components.ScrollBar,
  components.Space,
  components.FileFormatIcon,
  components.Space,
  { provider = '⟫' },
} --}}}

--- Left border component mode coloured
components.LeftBorderBlockModeColored = utils.insert(components.ModeColorModifier, components.LeftBorderBlock)

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
  { provider = '⟫' },
} --}}}

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
  { provider = '⟫' },
} --}}}

-- TODO: Change tolerable number of characters based on width percentage and remove percentage after
-- threshold <16-01-22, kunzaatko> --
--- 124:5   27%
components.Ruler = { --{{{
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = '%7(%l/%L%):%2c   %P',
} --}}}

--- Right border component block ⟪ 150:9  30% ▃
components.RightBorderBlock = { --{{{
  { provider = '⟪' },
  components.Space,
  components.Ruler,
  components.Space,
  components.ScrollBar,
} --}}}

--- Right border component mode coloured
components.RightBorderModeColored = utils.insert(components.ModeColorModifier, components.RightBorderBlock)

components.ShortRuler = { --{{{
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = '%7(%l/%L%)  ',
} --}}}

--- Right border terminal component block ⟪ 150:9  30% ▃
components.TerminalRightBorderBlock = { --{{{
  { provider = '⟪' },
  components.Space,
  components.ShortRuler,
  components.Space,
  components.BlockBar,
} --}}}

--- Right border terminal component block ⟪ 150:9  30% ▃
components.HelpRightBorderBlock = { --{{{
  { provider = '⟪' },
  components.Space,
  components.ShortRuler,
  components.Space,
  components.ScrollBar,
} --}}}

--- Modified / RO file flags
components.FileFlags = { --{{{
  {
    provider = function()
      if vim.bo.modified then
        return '  ' --  ,פֿ
      end
    end,
    hl = function(self)
      return { fg = self.colors.green }
    end,
  },
  {
    provider = function()
      if not vim.bo.modifiable or vim.bo.readonly then
        return '  ' --  ,,
      end
    end,
    hl = function(self)
      return { fg = self.colors.red }
    end,
  },
} --}}}

--- Component that contains initialization for the filename components
components.FileNameBlockInit = { --{{{
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.filename = filename
    -- FIX: `self.icon_color` may need a fallback value <15-01-22, kunzaatko> --
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
} --}}}

--- Get the filetype icon of curbuffer using `nvim-web-devicons` (must be child of FileNameBlockInit)
components.FileIcon = { --{{{
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
} --}}}

--- Get the filename of curbuffer with the colour of filetype (must be child of FileNameBlockInit)
components.FileName = { --{{{
  init = function(self)
    --- colour of the filename string to be 20 darker than the `icon_color`
    self.filename_color = hsl(self.icon_color).desaturate(50).hex
  end,
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = function(self)
    return { fg = self.filename_color }
  end,
} --}}}

--- Filename block component  heirline.lua פֿ
components.FileNameBlock = utils.insert( --{{{
  components.FileNameBlockInit,
  components.FileIcon,
  components.FileName,
  unpack(components.FileFlags),
  { provider = '%<' } -- mark for cut if there is not enough space
) --}}}

components.FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight('Type').fg, style = 'bold' },
}

components.FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end,
}

components.FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end,
}

---
components.FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize <= 0 then
      return '0' .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format('%.2g%s', fsize / math.pow(1024, i), suffix[i])
  end,
}

components.FileLastModified = {
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_gett_name(0))
    return (ftime > 0) and os.date('%c', ftime)
  end,
}

---

-- TODO: Add better colors and put ',' between <16-01-22, kunzaatko> --
-- TODO: Show specific parts of null-ls 'lsp-server' <16-01-22, kunzaatko> --
components.LSPActive = { --{{{
  condition = conditions.lsp_attached,
  utils.surround({ '  [', ']' }, nil, {
    static = {
      preferred_names = {
        sumneko_lua = 'lua',
        ['null-ls'] = 'null',
      },
    },
    init = function(self)
      self.names = {}
      for _, server in ipairs(vim.lsp.buf_get_clients(0)) do
        table.insert(self.names, self.preferred_names[server.name] or server.name)
      end
    end,
    provider = function(self)
      return table.concat(self.names, ' ')
    end,
    hl = function(self)
      return { fg = self.colors.purple, style = 'italic' }
    end,
  }),
  hl = function(self)
    return { fg = self.colors.yellow }
  end,
} --}}}

components.LSPMessages = { --{{{
  provider = function()
    local status = require('lsp-status').status() or ''
    local tail = #status > 1 and '⟨' or ''
    return status .. tail
  end,
  condition = #vim.lsp.buf_get_clients() > 0,
  hl = function(self)
    return { fg = self.colors.gray }
  end,
} --}}}
utils.make_flexible_component(2, components.LSPMessages, { provider = '' })

components.Gps = { --{{{
  condition = require('nvim-gps').is_available,
  provider = function()
    local location = require('nvim-gps').get_location() or ''
    local head = #location > 0 and conditions.is_active() and '⟩ ' or ''
    return head .. location
  end,
  hl = function(self)
    return { fg = self.colors.gray }
  end,
} --}}}
components.Gps = utils.make_flexible_component(3, components.Gps, { provider = '' })

---

-- TODO: Make nicer and edit colours and icons <16-01-22, kunzaatko> --
components.Diagnostics = { --{{{

  condition = conditions.has_diagnostics,

  static = {
    error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
    warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
    info_icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
    hint_icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  {
    provider = '![',
  },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.error }
    end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.warn }
    end,
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.info }
    end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = function(self)
      return { fg = self.colors.diag.hint }
    end,
  },
  {
    provider = ']',
  },
} --}}}

---

--  , , , ,  - for file changes in Neogit and/or Octo
components.Git = { --{{{
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = function(self)
    return { fg = self.colors.orange }
  end,

  { -- git branch name
    provider = function(self)
      return '  ' .. self.status_dict.head --  ,
    end,
    hl = { style = 'bold' },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = '(',
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ('+' .. count)
    end,
    hl = function(self)
      return { fg = self.colors.git.add }
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ('-' .. count)
    end,
    hl = function(self)
      return { fg = self.colors.git.del }
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ('~' .. count)
    end,
    hl = function(self)
      return { fg = self.colors.git.change }
    end,
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
} --}}}

-- TODO: Add more aligning components. <16-01-22, kunzaatko> --
components.Align = { provider = '%=' }

components.Snippets = { --{{{
  -- check that we are in insert or select mode
  condition = function()
    return vim.tbl_contains({ 's', 'i' }, vim.fn.mode())
  end,
  provider = function()
    local forward = (vim.fn['UltiSnips#CanJumpForwards']() == 1) and '' or ''
    local backward = (vim.fn['UltiSnips#CanJumpBackwards']() == 1) and '' or ''
    return backward .. ' ' .. forward
  end,
  hl = function(self)
    return { fg = self.colors.red, style = 'bold' }
  end,
} --}}}

--===
--- Normal focused buffer statusline
local StatusLineActive = { --{{{
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_colors = utils.hexify_color_spec(utils.mode_colors),
    colors = utils.hexify_color_spec(utils.base_color_spec),
  },
  hl = function(self)
    return {
      fg = self.colors.fg,
      bg = self.colors.bg,
    }
  end,
  components.LeftBorderBlockModeColored,
  components.Space,
  components.FileNameBlock,
  components.Space,
  components.Gps,
  components.Align,
  -- FIX: This does not work <16-01-22, kunzaatko> --
  components.LSPMessages,
  components.Space,
  components.Snippets,
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
    colors = utils.hexify_color_spec(utils.hsl_rec_map(utils.base_color_spec, function(hsl_col)
      return hsl_col.desaturate(50).darken(50)
    end)),
  },
  hl = function(self)
    return {
      fg = self.colors.fg,
      bg = self.colors.bg,
    }
  end,
  condition = function()
    return not conditions.is_active()
  end,
  components.LeftBorderBlock,
  components.Space,
  components.FileNameBlock,
  components.Align,
  components.Gps,
  components.Align,
  components.Diagnostics,
  components.Space,
  components.Git,
  components.Space,
  components.RightBorderBlock,
} --}}}

--- Terminal focused buffer statusline
local TerminalStatuslineActive = { --{{{
  static = {
    colors = utils.hexify_color_spec(utils.base_color_spec),
  },
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,

  hl = function(self)
    return {
      fg = self.colors.yellow,
      bg = self.colors.bg,
    }
  end,

  components.TerminalLeftBorderBlock,
  components.Align,
  components.TerminalRightBorderBlock,
} --}}}

--- Terminal unfocused buffer statusline
local TerminalStatusLineInactive = { --{{{
  static = {
    colors = utils.hexify_color_spec(utils.hsl_rec_map(utils.base_color_spec, function(hsl_col)
      return hsl_col.desaturate(50).darken(50)
    end)),
  },
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches { buftype = { 'terminal' } }
  end,
  hl = function(self)
    return {
      fg = self.colors.yellow,
      bg = self.colors.bg,
    }
  end,

  components.TerminalLeftBorderBlock,
  components.Align,
  components.TerminalRightBorderBlock,
} -- }}}

local HelpStatuslineActive = { --{{{
  static = {
    colors = utils.hexify_color_spec(utils.base_color_spec),
  },
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'help' },
    }
  end,
  hl = function(self)
    return {
      fg = self.colors.darkblue,
      bg = self.colors.bg,
    }
  end,

  components.HelpLeftBorderBlock,
  components.Align,
  components.HelpRightBorderBlock,
} --}}}

local HelpStatuslineInactive = { --{{{
  static = {
    colors = utils.hexify_color_spec(utils.hsl_rec_map(utils.base_color_spec, function(hsl_col)
      return hsl_col.desaturate(50).darken(50)
    end)),
  },
  condition = function()
    return not conditions.is_active() and conditions.buffer_matches {
      buftype = { 'help' },
    }
  end,
  hl = function(self)
    return {
      fg = self.colors.darkblue,
      bg = self.colors.bg,
    }
  end,

  components.HelpLeftBorderBlock,
  components.Align,
  components.HelpRightBorderBlock,
} --}}}

-- TODO: Add specific status lines for buf types
-- {'packer', 'neogit', 'neogitcommint', 'diff',
-- 'trouble','startify','helpfile','diffview','undotree', 'startuptime', 'octo', 'toggleterm',
-- 'terminal'
-- }
-- <16-01-22, kunzaatko> --
local StatusLines = {
  init = utils.pick_child_on_condition,
  HelpStatuslineInactive,
  HelpStatuslineActive,
  TerminalStatusLineInactive,
  TerminalStatuslineActive,
  StatusLineInactive,
  StatusLineActive,
}

return StatusLines
