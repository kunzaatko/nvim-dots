local wk = require 'which-key'
local util = require 'util'

_G.python = _G.python or {
  terminals = {},
}

local has_root, root =
  pcall(util.project.project_root, { '.git', 'Pipfile.lcok', 'Pipfile', 'README.md', 'requirements.txt' })
local root_or_file = has_root and root.filename or vim.api.nvim_buf_get_name(0)

local project_term = util.terminal.unique(root_or_file, {
  cmd = 'fish -c "pipenv shell"',
  autoclose = true,
}, { location = _G.python.terminals })

local global_term = util.terminal.unique('global', {
  cmd = { 'fish', '-c', 'ipython' },
  autoclose = true,
}, { location = _G.python.terminals })

wk.register({
  r = { name = string.format('%s %s', static.icons.terminal, 'REPL') },
}, { prefix = '<localleader>', buffer = 0 })

vim.api.nvim_buf_create_user_command(0, 'REPL', function()
  project_term:toggle(nil, true)
end, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', function()
  project_term:toggle(nil, false)
end, { desc = 'Python REPL for project', buffer = 0 })

-- NOTE: <leader><RightAlt + r>
vim.keymap.set('n', '<localleader>¶', function()
  global_term:toggle(nil, false)
end, { desc = 'Python REPL toggle', buffer = 0 })

vim.keymap.set('v', '¶', function()
  local vsel = require('util').get_vsel_text()
  table.insert(vsel, #vsel + 1, '')
  project_term:send(vsel)
  require('util').exit_vmode()
end, { desc = 'Send to REPL', buffer = 0 })

vim.keymap.set('t', '¶', require('terminal.mappings').toggle, { desc = 'Python REPL for project' })
