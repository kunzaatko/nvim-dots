-- TODO: Terminal to spawn in a vert split and windowbar to set depending whether the command finished or not  <12-05-23>
local wk = require 'which-key'
local term = require 'terminal'
local util = require 'util'

vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
vim.keymap.set('n', '<leader>lH', function()
  vim.notify(
    'Inlay hints ' .. (vim.lsp.inlay_hint.is_enabled { bufnr = 0 } and 'disabled' or 'enabled'),
    vim.log.levels.INFO,
    { icon = static.icons.ActiveLSP }
  )
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end, { desc = 'Toggle inlay hints', buffer = true })

wk.add({
  { '<localleader>c', group = string.format('%s %s', static.icons.ActiveLSP, 'Cargo') },
}, { buffer = true })

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
