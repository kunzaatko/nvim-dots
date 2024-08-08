-- TODO: Separate the components into a file and mark the components that are deprecated <15-03-22, kunzaatko> --
-- TODO: Document function and components <16-01-22, kunzaatko> --
local conditions = require 'heirline.conditions'
local api = vim.api
local utils = require(HEIRLINE_CONFIG_HOME .. '.utils')
local hsl = require 'lush.hsl'

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

-- TODO: Make a spinner fill scrollbar for the windowbar <12-05-23>
--- { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
components.ScrollBar = { --{{{
  static = {
    sbar = {
      '█',
      '▇',
      '▆',
      '▅',
      '▄',
      '▃',
      '▂',
      '▁',
    },
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
  local icons = static.icons.fileformat
  if icons[vim.bo.fileformat] then
    return icons[vim.bo.fileformat]
  else
    return icons.unknown
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
  { provider = static.icons.statusline.separators.rangle },
} --}}}

--- Left border component mode coloured
components.LeftBorderBlockModeColored = utils.insert(components.ModeColorModifier, components.LeftBorderBlock)

-- TODO: Change tolerable number of characters based on width percentage and remove percentage after
-- threshold <16-01-22, kunzaatko> --
--- 124:5   27%
components.Ruler = { --{{{
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = string.format('%s %s %s', '%7(%l/%L%):%2c', static.icons.statusline.linenumber, '%P'),
} --}}}

--- Right border component block ⟪ 150:9  30% ▃
components.RightBorderBlock = { --{{{
  { provider = static.icons.statusline.separators.langle },
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
  provider = string.format('%s %s', '%7(%l/%L%)', static.icons.statusline.linenumber),
} --}}}

--- Modified / RO file flags
components.FileFlags = { --{{{
  {
    provider = function()
      if vim.bo.modified then
        return ' ' .. static.icons.statusline.modified .. ' '
      end
    end,
    hl = function(self)
      return { fg = self.colors.base.green }
    end,
  },
  {
    provider = function()
      if not vim.bo.modifiable or vim.bo.readonly then
        return ' ' .. static.icons.statusline.readonly .. ' '
      end
    end,
    hl = function(self)
      return { fg = self.colors.base.red }
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
  hl = { fg = utils.get_highlight('Type').fg, bold = true },
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

components.Codeium = {
  condition = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return mode == 'i' and vim.g.codeium_enabled ~= nil
  end,
  utils.surround({ static.icons.ai .. '[', ']' }, nil, {
    provider = function()
      local status_string = vim.api.nvim_call_function('codeium#GetStatusString', {})
      return status_string:gsub('%s+', '')
    end,
  }),
}

-- TODO: Add better colors and put ',' or '|' between <16-01-22, kunzaatko> --
-- TODO: Show specific parts of null-ls 'lsp-server' <16-01-22, kunzaatko> --
components.LSPActive = { --{{{
  condition = conditions.lsp_attached,
  utils.surround({ static.icons.lsp.lsp .. '[', ']' }, nil, {
    static = {
      preferred_names = {
        lua_ls = 'lua',
        sumneko_lua = 'sumneko',
        ['null-ls'] = 'null',
        ['rust_analyzer-standalone'] = 'analyzer-standalone',
        ['rust_analyzer'] = 'analyzer',
        ['harper_ls'] = 'harper',
      },
    },
    init = function(self)
      self.names = {}
      for _, server in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
        table.insert(self.names, self.preferred_names[server.name] or server.name)
      end
    end,
    provider = function(self)
      return table.concat(self.names, ' ')
    end,
    hl = function(self)
      return { fg = self.colors.base.purple, italic = true }
    end,
  }),
  hl = function(self)
    return { fg = self.colors.base.yellow }
  end,
} --}}}

components.LSPMessages = { --{{{
  flexible = 2,
  provider = function()
    local status = require('lsp-status').status() or ''
    local tail = #status > 1 and '⟨' or ''
    return status .. tail
  end,
  condition = #vim.lsp.get_clients { bufnr = 0 } > 0,
  hl = function(self)
    return { fg = self.colors.base.gray }
  end,
} --}}}

-- components.Gps = { --{{{
--   condition = require('nvim-gps').is_available,
--   provider = function()
--     local location = require('nvim-gps').get_location() or ''
--     local head = #location > 0 and conditions.is_active() and '⟩ ' or ''
--     return head .. location
--   end,
--   hl = function(self)
--     return { fg = self.colors.base.gray }
--   end,
-- } --}}}
-- components.Gps = utils.make_flexible_component(3, components.Gps, { provider = '' })

---

-- TODO: Separate with '|' or something else <12-05-23>
-- TODO: Make nicer and edit colours and icons <16-01-22, kunzaatko> --
components.Diagnostics = { --{{{

  condition = conditions.has_diagnostics,

  static = {
    error_icon = static.icons.diagnostics.Error,
    warn_icon = static.icons.diagnostics.Warn,
    info_icon = static.icons.diagnostics.Info,
    hint_icon = static.icons.diagnostics.Hint,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  {
    provider = static.icons.diagnostics.diagnostics .. '[',
  },
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.errors .. self.error_icon .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.error }
    end,
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warnings .. self.warn_icon .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.warn }
    end,
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info .. self.info_icon .. ' ')
    end,
    hl = function(self)
      return { fg = self.colors.diag.info }
    end,
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hints .. self.hint_icon)
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

components.Timer = {
  condition = function(_)
    local ok, pomo = pcall(require, 'pomo')
    if not ok then
      return false
    else
      local timer = pomo.get_first_to_finish()
      if timer == nil then
        return false
      end
    end
    return true
  end,
  provider = function(_)
    local pomo = require 'pomo'
    local timer = pomo.get_first_to_finish()
    return '󰄉 ' .. tostring(timer):gsub('#1: ', '')
  end,
  hl = function(self)
    return { fg = self.colors.base.orange }
  end,
}

---

-- TODO: Separate git additions with `|` or some other separator <12-05-23>
--  , , , ,  - for file changes in Neogit and/or Octo
components.Git = { --{{{
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = function(self)
    return { fg = self.colors.base.orange }
  end,

  { -- git branch name
    provider = function(self)
      -- FIX: Git branch does not work <12-05-23>
      return string.format('%s%s', static.icons.git.branch, self.status_dict.head)
    end,
    hl = { bold = true },
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
      return count > 0 and (count .. static.icons.git.add)
    end,
    hl = function(self)
      return { fg = self.colors.git.add }
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (count .. static.icons.git.delete)
    end,
    hl = function(self)
      return { fg = self.colors.git.del }
    end,
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (count .. static.icons.git.change)
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

return components
