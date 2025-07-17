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
  -- TODO: When the markdown buffer is the current one, I do not want so much concealment as it makes editing more
  -- difficult <25-06-25>
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', { 'nvim-tree/nvim-web-devicons', name = 'devicons' } },
    ft = { 'markdown' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    -- opts = {},
    -- TODO: Configure <14-12-24>
    config = true,
  },
}
