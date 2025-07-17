-- TODO: Terminal to spawn in a vert split and windowbar to set depending whether the command finished or not  <12-05-23>
local wk = require 'which-key'
local termutil = require 'util.terminal'

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
    termutil.oneshot('cargo ' .. option, {
      interactive = false,
      win = { position = 'right' },
    })
  end)
end, { buffer = true, desc = 'Cargo clippy|check' })

vim.keymap.set('n', '<localleader>cb', function()
  termutil.oneshot('cargo build', { interactive = false, win = { position = 'right' } })
end, { buffer = true, desc = 'Cargo build' })

vim.keymap.set('n', '<localleader>cr', function()
  termutil.oneshot('cargo run', { interactive = false, win = { position = 'right' } })
end, { buffer = true, desc = 'Cargo run' })

vim.keymap.set('n', '<localleader>cd', function()
  termutil.oneshot('cargo doc --document-private-items', { interactive = false, win = { position = 'right' } })
end, { buffer = true, desc = 'Cargo doc' })

vim.keymap.set('n', '<localleader>t', function()
  termutil.oneshot('cargo test', {
    start_insert = false,
    auto_insert = false,
    auto_close = false,
    win = { position = 'right' },
  })
end, { buffer = true, desc = 'Cargo test' })
