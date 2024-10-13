if pcall(require, 'peek') then
  vim.keymap.set('n', '<localleader>o', '<cmd>PeekOpen<CR>', { desc = 'open output with peek', buffer = true })
end
