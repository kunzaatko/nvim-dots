-- TODO: Terminal send keymap <16-04-25>
local term = require 'util.terminal'

local PYTHON_PROJECT_REPL_CMD = 'pipenv run ipython'
local PYTHON_REPL_CMD = 'ipython'

vim.api.nvim_buf_create_user_command(0, 'PythonREPL', function()
  term.toggle_repl(PYTHON_PROJECT_REPL_CMD, '¶')
end, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', function()
  term.toggle_repl(PYTHON_PROJECT_REPL_CMD, '¶')
end, { desc = 'Python REPL for project', buffer = 0 })

-- NOTE: <leader><RightAlt + r>
vim.keymap.set('n', '<localleader>¶', function()
  term.toggle_repl(PYTHON_REPL_CMD, '¶')
end, { desc = 'Python REPL toggle', buffer = 0 })
