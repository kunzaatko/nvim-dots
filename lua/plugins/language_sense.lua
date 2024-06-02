return {
  {
    -- TODO: Add keymaps <10-01-23>
    'danymat/neogen',
    dependencies = { { 'nvim-treesitter/nvim-treesitter', name = 'treesitter' } },
    opts = {
      snippet_engine = 'luasnip',
    },
    config = true,
  },

  -- FIX: Do I need null-ls any more!!! <02-06-24, kunzaatko>
  -- TODO: Do not select the ones that are loaded first <02-05-23>
  -- FIX: Does not load before saving (maybe on new files). There should be an event that will load it before saving <11-01-23>
  {
    'jose-elias-alvarez/null-ls.nvim',
    name = 'null-ls',
    event = 'BufReadPre',
    dependencies = {
      { 'nvim-lua/plenary.nvim', name = 'plenary' },
      'mason',
    },
    -- TODO: Add filetypes that use diagnostics tools that from null-ls <09-01-23>
    ft = { 'fish', 'toml' },

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
          null_ls.builtins.formatting.taplo, -- TOML
          null_ls.builtins.diagnostics.flake8, -- Python
          -- null_ls.builtins.diagnostics.codespell,
          -- null_ls.builtins.diagnostics.pydocstyle,
          -- null_ls.builtins.diagnostics.proselint,
          -- null_ls.builtins.code_actions.proselint,
          -- null_ls.builtins.hover.dictionary,
          -- null_ls.builtins.diagnostics.misspell.with {
          --   extra_args = { '-locale', 'UK', '-i', M.MISSPELL_IGNORE },
          -- },
          -- TODO: Add vale to sources, when documentation in julia package <11-01-23>
          -- TODO: Add thesaurus source to null-ls for hover and codeaction <13-01-23>
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
