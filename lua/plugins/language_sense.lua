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
    },
    ft = { 'fish', 'toml', 'python', 'c', 'lua', 'yapf' },

    config = function()
      local null_ls = require 'null-ls'
      null_ls.setup {
        sources = {
          -- NOTE: Tools from sources can be added to lua/plugins/lsp/init.lua to applications that are ensured to be
          -- installed by mason.nvim <11-01-23>
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.hover.dictionary,
        },
      }
    end,
  },
}
