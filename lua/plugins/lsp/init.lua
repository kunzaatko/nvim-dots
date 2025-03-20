local M = {
  {
    'neovim/nvim-lspconfig',
    name = 'lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason',
      { 'williamboman/mason-lspconfig.nvim', name = 'mason-lspconfig' },
      'saghen/blink.cmp',
    },
    opts = {
      servers = require 'plugins.lsp.servers',
    },
    config = function(_, opts)
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
      })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
      })

      require('util').lsp.on_attach(function(client, buffer)
        require('plugins.lsp.format').on_attach(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      require('mason-lspconfig').setup_handlers {
        function(server)
          local server_opts = opts.servers[server] or {}
          server_opts.capabilities =
            require('util').lsp.add_capabilities(require('blink.cmp').get_lsp_capabilities(server_opts.capabilities))
          require('lspconfig')[server].setup(server_opts)
        end,
      }
      -- opts.servers.texlab.capabilities =
      --   require('blink.cmp').get_lsp_capabilities(opts.servers.texlab.capabilities or {})
      -- require('lspconfig').texlab.setup(opts.servers.texlab)

      -- require('lspconfig').ltex.setup(opts.servers.ltex) -- FIX: not working with current Java installation
      -- FIX: For some reason this server is not configured. My hypothesis is that it does not get configured due to it
      -- not being installed by Mason... This explicit setting up solves it <25-04-24>
      opts.servers.ccls.capabilities = require('blink.cmp').get_lsp_capabilities(opts.servers.ccls.capabilities or {})
      require('lspconfig').ccls.setup(opts.servers.ccls)
    end,
  },
  {
    'williamboman/mason.nvim',
    name = 'mason',
    cmd = 'Mason',
    opts = {
      ensure_installed = {
        'stylua',
        'yapf',
        'shellcheck',
        'shfmt',
        'flake8',
        'clang-format',
        'proselint',
        'misspell',
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
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
  -- TODO: Use the noice.nvim interface for renaming <11-05-23>
  { 'smjonas/inc-rename.nvim', opts = { input_buffer_type = 'dressing' }, event = 'VeryLazy', cmd = 'IncRename' },
  {
    'aznhe21/actions-preview.nvim',
    event = 'VeryLazy',
    opts = {
      diff = {
        algorithm = 'patience',
        ignore_whitespace = true,
      },
      telescope = require('telescope.themes').get_dropdown { winblend = 10 },
    },
  },
  {
    'ray-x/lsp_signature.nvim',
    name = 'lsp-signature',
    event = 'InsertEnter',
    opts = {
      hint_enable = false,
      transparency = 10,
    },
  },
}

return M
