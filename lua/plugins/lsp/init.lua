-- TODO: I would like to have a context in the buffer for what class I am in. Possibly only for some filetypes. Maybe
-- in the `statusline`. Maybe in the `bufferline`. <17-03-2026>
local M = {
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    lazy = false,
    cmd = { 'LspStart', 'LspStop', 'LspInfo', 'LspRestart', 'LspLog' },
    init = function()
      local lspConfigPath = require('lazy.core.config').options.root .. '/nvim-lspconfig'
      vim.opt.runtimepath:prepend(lspConfigPath)
    end,
  },
  {
    'williamboman/mason.nvim',
    name = 'mason',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'yapf',
        'shellcheck',
        'flake8',
        'clang-format',
        'proselint',
        'misspell',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require 'mason-registry'
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}

return M
