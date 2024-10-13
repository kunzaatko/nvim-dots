-- TODO: Terminal to spawn in a vert split and windowbar to set depending whether the command finished or not  <12-05-23>
local wk = require 'which-key'
local term = require 'terminal'
local util = require 'util'

wk.add({
  c = { name = string.format('%s %s', static.icons.ActiveLSP, 'Cargo') },
}, { prefix = '<localleader>', buffer = true })

vim.keymap.set('n', '<localleader>cc', function()
  vim.ui.select({ 'clippy', 'check' }, { prompt = 'Check with:' }, function(option)
    util.terminal.oneshot {
      cmd = 'fish -c "cargo ' .. option .. '"',
      autoclose = false,
      layout = { open_cmd = 'botright vertical new' },
    }
  end)
end, { buffer = true, desc = 'Cargo clippy' })

vim.keymap.set('n', '<localleader>cb', function()
  util.terminal.oneshot {
    cmd = 'fish -c "cargo build"',
    autoclose = false,
    layout = { open_cmd = 'botright vertical new' },
  }
end, { buffer = true, desc = 'Cargo build' })

vim.keymap.set('n', '<localleader>cr', function()
  util.terminal.oneshot {
    cmd = 'fish -c "cargo run"',
    autoclose = false,
    layout = { open_cmd = 'botright vertical new' },
  }
end, { buffer = true, desc = 'Cargo run' })

vim.keymap.set('n', '<localleader>cd', function()
  util.terminal.oneshot {
    cmd = 'fish -c "cargo doc --document-private-items"',
    autoclose = false,
    layout = { open_cmd = 'botright new' },
  }
end, { buffer = true, desc = 'Cargo doc' })

vim.keymap.set('n', '<localleader>t', function()
  util.terminal.oneshot {
    cmd = 'fish -c "cargo test"',
    autoclose = false,
    layout = { open_cmd = 'botright vertical new' },
  }
end, { buffer = true, desc = 'Cargo test' })
