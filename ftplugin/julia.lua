-- TODO: Add autopairs `endwise` rules for "begin end" groups and for "do end" https://github.com/windwp/nvim-autopairs/wiki/Endwise#list-rule-predefined-by-user <11-05-23>

-- FIX: The terminal should be only allowed to launch from a julia file and if I open different files from different
-- projects, I should get a different REPL <12-05-23>

local wk = require 'which-key'
local util = require 'util'

_G.julia = _G.julia or {
  terminals = {},
}

local has_root, root =
  pcall(util.project.project_root, { 'Project.toml', 'Manifest.toml', '.git', 'README.md', 'readme.md' })
local root_or_file = has_root and root.filename or vim.api.nvim_buf_get_name(0)

local project_term = util.terminal.unique(root_or_file, {
  cmd = 'fish -c "julia --project"',
  autoclose = true,
}, { location = _G.julia.terminals })

local global_term = util.terminal.unique('global', {
  cmd = { 'fish', '-c', 'julia' },
  autoclose = true,
}, { location = _G.julia.terminals })

wk.register({
  r = { name = string.format('%s %s', static.icons.terminal, 'REPL') },
}, { prefix = '<localleader>', buffer = 0 })

vim.api.nvim_buf_create_user_command(0, 'REPL', function()
  project_term:toggle(nil, true)
end, { nargs = '?' })

-- NOTE: <RightAlt + r>
vim.keymap.set('n', '¶', function()
  project_term:toggle(nil, false)
end, { desc = 'Julia REPL for project', buffer = 0 })

-- NOTE: <leader><RightAlt + r>
vim.keymap.set('n', '<localleader>¶', function()
  global_term:toggle(nil, false)
end, { desc = 'Julia REPL toggle', buffer = 0 })

-- FIX: Test terminal should be vertical on the right side <13-05-23, kunzaatko>
vim.keymap.set('n', '<localleader>t', function()
  util.terminal.oneshot {
    cmd = 'fish -c "julia --project --eval \'using Pkg; Pkg.test()\'"',
    autoclose = false,
    layout = { open_cmd = 'enew' },
  }
end, { desc = 'Run tests', buffer = 0 })

-- TODO: text motion enable (!!!) <kunzaatko>
-- BUG: Sometimes errors with invalid argument to chansend()... Either a problem with the plugin or with my
-- definition of the terminal <14-05-23, kunzaatko>
-- FIX: The problem is that the terminal variable is changed and so is not running. The solution is to make a function
-- for creating terminals that checks whether the terminal is running and starts is for different sessions automatically
-- if it is not. We need to store the terminal for the current session by the creation function and send the data to the
-- relevant terminal.
-- FIX: Does not work when the terminal is not launched before the sending <13-05-23>
vim.keymap.set('v', '¶', function()
  local vsel = require('util').get_vsel_text()
  table.insert(vsel, #vsel + 1, '')
  project_term:send(vsel)
  require('util').exit_vmode()
end, { desc = 'Send to REPL', buffer = 0 })

vim.keymap.set('v', '<localleader>?', function()
  local vsel = require('util').get_vsel_text()
  assert(#vsel == 1, 'Invalid selection: Selection must by a single line')
  vsel[1] = '??' .. vsel[1]
  table.insert(vsel, #vsel + 1, '')
  project_term:send(vsel)
  require('util').exit_vmode()

  -- TODO: Open with no focus <18-05-23>
  project_term:open()
end, { desc = 'Send to REPL', buffer = 0 })

-- FIX: This will work only when one REPL terminal at a time is defined... That is if I have python and julia active
-- this will fail... Should be set by autocommand and only with some pattern that determines if the REPL is a julia
-- REPL or a python REPL etc. <kunzaatko>
vim.keymap.set('t', '¶', require('terminal.mappings').toggle, { desc = 'Julia REPL for project' })
vim.keymap.set('n', '<localleader>rm', function()
  vim.ui.input({ prompt = 'Which module to activate?' }, function(module)
    if not module then
      return
    end
    project_term:send('using REPL;REPL.activate(' .. module .. ')')
  end)
end, { desc = 'Activate the current project module', buffer = 0 })
