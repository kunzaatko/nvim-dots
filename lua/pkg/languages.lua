local M = {
  -- FIX: There is a bug that causes this to give errors when it is an opt plug-in on several events
  -- <17-11-21, kunzaatko> --
  -- {'JuliaEditorSupport/julia-vim', as = 'julia'}, -- mainly for LaTeX to Unicode support

  -- 'rust-lang/rust.vim' -- Playpen integration, :RunTest{{{
  {
    'rust-lang/rust.vim',
    as = 'rust',
    ft = 'rust',
    config = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  -- }}}

  -- 'simrat39/rust-tools.nvim' -- LSP rust specifics{{{
  {
    'simrat39/rust-tools.nvim',
    as = 'rust_tools',
    ft = 'rust',
    config = function()
      require('rust-tools').setup()
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'neovim/nvim-lspconfig',
    },
  },
  -- }}}

  -- 'lervag/vimtex' -- continuous compilation, folding, indenting etc.{{{
  {
    'lervag/vimtex',
    ft = 'tex',
    setup = function()
      require 'conf.pkgs.vimtex'
    end,
  },
  -- }}}

  -- 'kovetskiy/sxhkd-vim' -- SXHKD spec file support{{{
  {
    'kovetskiy/sxhkd-vim',
    as = 'sxhkd',
    ft = 'sxhkd',
  },
  -- }}}

  -- TOML language support
  { 'cespare/vim-toml', as = 'toml', ft = 'toml' },

  -- fish scripts support
  { 'blankname/vim-fish', as = 'fish', ft = 'fish' },
}

return M
