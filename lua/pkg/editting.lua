local M = {
  { 'godlygeek/tabular', cmd = 'Tabularize' },

  -- TODO: Configure <16-01-22, kunzaatko> --
  -- 'windwp/nvim-autopairs' -- automatically adding matching delimiters {{{
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup()
      vim.notify 'This is Loading'
    end,
  },
  -- }}}

  -- TODO: Add repeat capability <16-01-22, kunzaatko> --
  -- 'blackCauldron7/surround.nvim' -- text objects and editing surrounding delimiters{{{
  {
    'ur4ltz/surround.nvim',
    config = function()
      require('surround').setup { mappings_style = 'surround' }
    end,
  },
  -- }}}

  -- 'b3nj5m1n/kommentary' -- commenting {{{
  {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language('default', { prefer_single_line_comments = true })
    end,
  },
  -- }}}

  -- abbreviations
  -- TODO: Do this in lua <16-01-22, kunzaatko> --
  'tpope/vim-abolish',
}
return M
