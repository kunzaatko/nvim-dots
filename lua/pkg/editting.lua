-- local utils = require 'pkg.utils'

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
    after = 'cmp',
  },
  -- }}}

  -- TODO: Add repeat capability <16-01-22, kunzaatko> --
  -- TODO: Add mapping defered loading <12-03-22, kunzaatko> --
  -- 'ur4ltz/surround.nvim' -- text objects and editing surrounding delimiters{{{
  {
    'ur4ltz/surround.nvim',
    as = 'surround',
    config = function()
      require('surround').setup { mappings_style = 'surround' }
    end,
  },
  -- }}}

  -- 'numToStr/Comment.nvim' -- commenting {{{
  {
    'numToStr/Comment.nvim',
    as = 'Comment',
    -- keys = utils.get_multi_keys {
    --   { 'v', { { 'g' }, { 'b', 'c' } } },
    --   { 'n', { { 'gc' }, { '', 'c', 'o', 'O', 'A' } } },
    --   { 'n', { { 'gb' }, { '', 'c' } } },
    -- },
    config = function()
      require('Comment').setup {}
    end,
  },
  -- }}}

  -- TODO: Add conditional loading for the languages necessary with packer `ft` <kunzaatko>
  -- 'eraserhd/parinfer-rust' - for indentation and brackets with LISPlike languages {{{
  {
    'eraserhd/parinfer-rust',
    run = 'cargo build --release',
  },
  -- }}}

  -- TODO: Do this using LuaSnips as abbreviations in the file of abbreviations <11-07-22, kunzaatko>
  -- 'tpope/vim-abolish' -- abbreviations {{{
  {
    'tpope/vim-abolish',
    as = 'abolish',
    event = 'InsertEnter',
  },
  -- }}}
}
return M
