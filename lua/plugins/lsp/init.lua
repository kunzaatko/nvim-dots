local M = {
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    dependencies = {
      'mason',
      { 'williamboman/mason-lspconfig.nvim', name = 'mason-lspconfig' },
      'saghen/blink.cmp',
    },
    opts = {
      servers = require 'plugins.lsp.servers',
    },
    config = function(_, opts)
      require('mason-lspconfig').setup_handlers {
        function(server)
          local server_opts = opts.servers[server] or {}
          server_opts.capabilities = require('util.lsp').get_capabilities()
          require('lspconfig')[server].setup(server_opts)
        end,
      }
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
