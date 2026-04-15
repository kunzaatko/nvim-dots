-- TODO: I would like to have a context in the buffer for what class I am in. Possibly only for some filetypes. Maybe
-- in the `statusline`. Maybe in the `bufferline`. <17-03-2026>
local M = {
  'neovim/nvim-lspconfig',
  name = 'lspconfig',
  lazy = false,
  cmd = { 'LspStart', 'LspStop', 'LspInfo', 'LspRestart', 'LspLog' },
  init = function()
    local lspConfigPath = require('lazy.core.config').options.root .. '/nvim-lspconfig'
    vim.opt.runtimepath:prepend(lspConfigPath)
  end,
}

return M
