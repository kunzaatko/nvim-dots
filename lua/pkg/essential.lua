local M = {
  -- TODO: Is this fixed? <16-01-22, kunzaatko> --
  -- bug in neovim - https://github.com/neovim/neovim/issues/12587
  { 'antoinemadec/FixCursorHold.nvim', as = 'FixCursorHold' },
  -- speeds-up the start-up time by using a lua version of the filetype.vim script
  { 'nathom/filetype.nvim', as = 'filetype' },
  -- speed up on startuptime by compliling plugins into bytestrings
  { 'lewis6991/impatient.nvim', as = 'impatient' },
}

return M
