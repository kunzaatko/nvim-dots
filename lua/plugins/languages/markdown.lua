return {
  {
    'toppair/peek.nvim',
    name = 'peek',
    build = 'deno task --quiet build:fast',
    cmd = { 'PeekOpen', 'PeekClose' },
    opts = {
      theme = 'light',
      app = 'browser',
    },
    config = function(_, opts)
      require('peek').setup(opts)
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    -- TODO: Consider adding other filetypes <18-04-23>
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', name = 'treesitter' },
    opts = {},
    config = function()
      require('headlines').setup()
      -- TODO: Change the highlights <18-04-23>
      vim.cmd [[highlight Headline1 guibg=#1e2718]]
      vim.cmd [[highlight Headline2 guibg=#21262d]]
      vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
      vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]
    end,
  },
}
