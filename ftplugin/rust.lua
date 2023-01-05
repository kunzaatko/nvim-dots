vim.api.nvim_create_augroup('TreesitterFolding', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  group = 'TreesitterFolding',
  desc = 'Override `foldmethod` to fold via treesitter',
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr'
  end,
})
