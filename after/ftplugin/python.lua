-- TODO: Terminal send keymaps do not indent correctly. Should be probably stripped, since the ipython repl adds the
-- indentation by itself. <16-04-25>
local term = require 'util.terminal'

local PYTHON_PROJECT_REPL_CMD = 'uv run ipython'
local PYTHON_REPL_CMD = 'ipython'

local function python_project_repl()
  term.toggle_repl(
    PYTHON_PROJECT_REPL_CMD,
    '¶',
    { win = {
      wo = {
        winbar = '%=Python - Project REPL%=',
      },
    } },
    '¶'
  )
end

vim.api.nvim_buf_create_user_command(0, 'PythonREPL', python_project_repl, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', python_project_repl, { desc = 'Python REPL for project', buffer = true })

-- NOTE: <leader><RightAlt + r>
vim.keymap.set('n', '<localleader>¶', function()
  term.toggle_repl(
    PYTHON_REPL_CMD,
    '<localleader>¶',
    { win = { wo = { winbar = '%=Python - REPL%=' } } },
    '<localleader>¶'
  )
end, { desc = 'Python REPL toggle', buffer = true })
