local utils = require 'pkg.utils'

local M = {
  { 'godlygeek/tabular', cmd = 'Tabularize' },

  -- TODO: Configure <16-01-22, kunzaatko> --
  -- 'windwp/nvim-autopairs' -- automatically adding matching delimiters {{{
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup()
    end,
  },
  -- }}}

  -- TODO: Add repeat capability <16-01-22, kunzaatko> --
  -- 'ur4ltz/surround.nvim' -- text objects and editing surrounding delimiters{{{
  {
    'ur4ltz/surround.nvim',
    config = function()
      require('surround').setup { mappings_style = 'surround' }
    end,
  },
  -- }}}

  -- 'numToStr/Comment.nvim' -- commenting {{{
  {
    'numToStr/Comment.nvim',
    keys = utils.get_multi_keys {
      { 'n', { { 'gc' }, { '', 'c', 'o', 'O', 'A' } } },
      { 'n', { { 'gb' }, { '', 'c' } } },
      { 'n', { { 'g' }, { '>', '<', '<c', '<b', '>c', '>b' } } },
      { 'v', { { 'g' }, { '>', '<' } } },
    },
    config = function()
      require('Comment').setup { mappings = { extended = true } }
    end,
  },
  -- }}}

  -- abbreviations
  -- TODO: Do this in lua <16-01-22, kunzaatko> --
  {
    'tpope/vim-abolish',
    event = 'InsertEnter',
  },
}
return M
