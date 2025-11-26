local utils = require 'heirline.utils'
local hsl = require 'lush.hsl'

--- `utils.hsl_rec_map` - Recursively maps a function over an HSL object or table of HSL objects.
--- @param entry table[table]: HSL object or table of HSL objects to map over.
--- @param hsl_func (function): function to apply to each HSL object.
--- @return (table): A new table with the same structure as the input table, but with each HSL object replaced by the result of applying `hsl_func` to it.
--- @raises: None
utils.hsl_rec_map = function(entry, hsl_func)
  if vim.tbl_contains(vim.tbl_keys(getmetatable(entry) or {}), '__call') then -- is hsl object
    return hsl_func(entry)
  else
    return vim.tbl_map(function(i)
      return utils.hsl_rec_map(i, hsl_func)
    end, entry)
  end
end

--- hex the hsl colours and recurse into table layers
--- @param entry table
--- @return table[string] hex colour
utils.hexify_color_spec = function(entry)
  return utils.hsl_rec_map(entry, function(hsl_entry)
    return hsl_entry.hex
  end)
end

utils.get_highlight_hex = function(hlname, component)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlname)), component .. '#')
end

local or_backup = function(a, backup)
  return a ~= '' and a or backup
end

--- Prefixes all keys in the source table with the given prefix
--- @param src table source table
--- @param prefix string prefix for the keys
--- @return table src Source table with prefixed keys
local function prefix_keys(src, prefix)
  local out = {}
  for k, v in pairs(src) do
    out[prefix .. k] = v
  end
  return out
end

utils.setup_colors = function()
  local base = {
    fg = hsl(or_backup(utils.get_highlight_hex('Normal', 'fg'), '#D8DEE9')), -- #D8DEE9
    bg = hsl(or_backup(utils.get_highlight_hex('WinSeparator', 'fg'), '#171523')), -- #171523 #181B21
    red = hsl(or_backup(utils.get_highlight_hex('SpellBad', 'fg'), '#BE6069')), -- #BE6069
    magenta = hsl(or_backup(utils.get_highlight_hex('Float', 'fg'), '#B48EAD')), -- #B48EAD
    green = hsl(or_backup(utils.get_highlight_hex('Character', 'fg'), '#A4BF8D')), -- #A4BF8D
    blue = hsl(or_backup(utils.get_highlight_hex('Conditional', 'fg'), '#81A1C1')), -- #81A1C1
    darkblue = hsl(or_backup(utils.get_highlight_hex('DiagnosticHint', 'fg'), '#5D81AC')), -- #5D81AC
    yellow = hsl(40, 71, 73), -- #EBCA89
    orange = hsl(14, 51, 63), -- #D18771
    gray = hsl(utils.get_highlight_hex('NonText', 'fg')),
    purple = hsl(or_backup(utils.get_highlight_hex('Float', 'fg'), '#A77B9F')).da(10), -- #A77B9F
    cyan = hsl(or_backup(utils.get_highlight_hex('Function', 'fg'), '#87BFCF')), -- #87BFCF
  }

  local diag = {
    warn = hsl(utils.get_highlight_hex('DiagnosticWarn', 'fg')),
    error = hsl(utils.get_highlight_hex('DiagnosticError', 'fg')),
    hint = hsl(utils.get_highlight_hex('DiagnosticHint', 'fg')),
    info = hsl(utils.get_highlight_hex('DiagnosticInfo', 'fg')),
  }

  local git = {
    del = hsl(or_backup(utils.get_highlight_hex('DiffDelete', 'fg'), '#BE6069')),
    add = hsl(or_backup(utils.get_highlight_hex('DiffAdd', 'fg'), '#A4BF8D')),
    change = hsl(or_backup(utils.get_highlight_hex('DiffChange', 'fg'), '#EBCA89')),
    branch = hsl(or_backup(utils.get_highlight_hex('gitcommitBranch', 'fg'), '#D18771')),
  }

  local colors_hsl =
    vim.tbl_extend('force', prefix_keys(base, 'base_'), prefix_keys(git, 'git_'), prefix_keys(diag, 'diag_'))

  colors_hsl = vim.tbl_extend(
    'force',
    colors_hsl,
    prefix_keys(
      utils.hsl_rec_map(colors_hsl, function(hsl_col)
        return hsl_col.desaturate(50).darken(50)
      end),
      'inactive_'
    )
  )

  utils.color_spec = utils.hexify_color_spec(colors_hsl)

  require('heirline').load_colors(utils.hexify_color_spec(colors_hsl))
end

return utils
