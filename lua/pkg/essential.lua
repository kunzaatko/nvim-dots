local M = {
  -- TODO: Add `bufdelete.nvim`  and `neo-tree.nvim` <kunzaatko>
  -- TODO: consider better-escape.nvim <kunzaatko>

  -- FIX: Does not work with VimTex <23-10-22>
  -- Highlight in fold text {{{
  {
    'milisims/foldhue.nvim',
    config = function()
      require('foldhue').enable()
    end,
  }, -- }}}

  -- -- speeds-up the start-up time by using a lua version of the filetype.vim script {{{
  -- {
  --   'nathom/filetype.nvim',
  --   as = 'filetype',
  --   config = function()
  --     require('filetype').setup {
  --       overrides = {
  --         literal = {
  --           sxhkdrc = 'sxhkd',
  --         },
  --         complex = {
  --           ['.*/papis/config'] = 'toml',
  --         },
  --         shebang = {
  --           dash = 'sh',
  --         },
  --       },
  --     }
  --   end,
  -- }, -- }}}

  -- speed up on start-up time by compiling plug-ins into byte strings
  { 'lewis6991/impatient.nvim', as = 'impatient' },
}

return M
