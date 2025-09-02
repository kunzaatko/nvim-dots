-- TODO: Terminal send keymaps do not indent correctly. Should be probably stripped, since the ipython repl adds the
-- indentation by itself. <16-04-25>
local term = require 'util.terminal'

local PYTHON_PROJECT_REPL_CMD = 'uv run ipython'
local PYTHON_REPL_CMD = 'ipython'

-- FIX: The first indentations should be left and all the rest indentations that match the indentation should be
-- removed until the indentation that is higher than the one that was previously. <29-08-25>
--- Format the lines before sending them to the REPL
---@param text string: The input text
---@return string: The modified text
local function send_format(text)
  local lines = {}
  for line in text:gmatch '([^\n]*)\n?' do
    if line ~= '' then
      -- Trim leading and trailing whitespace
      local modified_line = line:gsub('^%s*(.-)%s*$', '%1')
      table.insert(lines, modified_line)
    end
  end
  return table.concat(lines, '\n') .. (text:sub(-1) == '\n' and '\n' or '')
end

local function python_project_repl()
  term.toggle_repl(
    PYTHON_PROJECT_REPL_CMD,
    '¶',
    { win = {
      wo = {
        winbar = '%=Python - Project REPL%=',
      },
    } },
    '¶',
    send_format
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
    '<localleader>¶',
    send_format
  )
end, { desc = 'Python REPL toggle', buffer = true })
