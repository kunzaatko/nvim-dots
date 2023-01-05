local Terminal = require('toggleterm.terminal').Terminal
local map = vim.keymap.set
_G.julia = _G.julia or {}
_G.julia.JuliaREPL = Terminal:new {
  -- TODO: should check if the tmux session is active <13-03-22, kunzaatko> --
  cmd = 'tmux a -t JREPL',
  -- TODO: Rename the window of the terminal <13-03-22, kunzaatko> --
  -- TODO: funcition on_open should set keymaps for testing and for attaching to the current sessio
  -- julia environment if it exists <13-03-22, kunzaatko> --
}

-- NOTE: This rewrites the default toggleterm terminal since it overwrites the openning command  <kunzaatko> --
map('n', '<C-p>', function()
  _G.julia.JuliaREPL:toggle()
end, { silent = true, desc = 'toggle julia REPL' })

vim.opt.textwidth = 92
