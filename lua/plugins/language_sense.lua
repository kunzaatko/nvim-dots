return {
  {
    -- TODO: Add keymaps <10-01-23>
    'danymat/neogen',
    dependencies = { { 'nvim-treesitter/nvim-treesitter', name = 'treesitter' } },
    event = 'VeryLazy',
    cmd = { 'Neogen' },
    opts = {
      snippet_engine = 'luasnip',
    },
    config = true,
  },

  -- TODO: Do not select the ones that are loaded first <02-05-23>
  -- FIX: Does not load before saving (maybe on new files). There should be an event that will load it before saving
  -- <11-01-23>
  {
    'nvimtools/none-ls.nvim',
    name = 'none-ls',
    event = 'BufReadPre',
    dependencies = {
      { 'nvim-lua/plenary.nvim', name = 'plenary' },
      'mason',
    },
    ft = { 'fish', 'toml', 'python', 'c', 'lua', 'yapf' },

    config = function()
      M.MISSPELL_IGNORE = 'specializations,'
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          -- NOTE: Tools from sources can be added to lua/plugins/lsp/init.lua to applications that are ensured to be
          -- installed by mason.nvim <11-01-23>
          null_ls.builtins.formatting.clang_format, -- C
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.yapf, -- Python
          -- null_ls.builtins.formatting.taplo, -- TOML -- FIX: Add though conform <08-08-24>
          -- null_ls.builtins.diagnostics.flake8, -- Python
          null_ls.builtins.formatting.blackd,
        },
      }
      -- FIXIT: Being moved to LSP and a global call setup can then be moved to `opts` <10-01-23>
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.lua', '*.py', '*.toml', '*.fish' },
        desc = 'Format filetypes of save',
        group = vim.api.nvim_create_augroup('FormatOnSave', {}),
        callback = function()
          -- TODO: Should be ensured that the plugin is loaded and then the file should be saved <09-01-23>
          vim.lsp.buf.format { async = false, name = 'null-ls' }
        end,
      })
    end,
  },
}
