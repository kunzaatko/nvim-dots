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
    setup = function()
      -- NOTE: Fix the SXHKD filetype detection issue <kunzaatko> --
      _G.AUtils.check_ft_sxhkd = function()
        if packer_plugins['plenary.nvim'].loaded ~= true then
          vim.cmd [[packadd plenary.nvim]]
        end
        local p = require('plenary').path.new(vim.api.nvim_buf_get_name(0))
        if p:_split()[#p:_split()] == 'sxhkdrc' then
          vim.opt.filetype = 'sxhkd'
        end
      end

      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      vim.cmd [[ autocmd BufRead * call v:lua.AUtils.check_ft_sxhkd() ]]
    end,
  },
  -- }}}

  -- TOML language support
  { 'cespare/vim-toml', as = 'toml', ft = 'toml' },

  -- fish scripts support
  { 'blankname/vim-fish', as = 'fish', ft = 'fish' },
}

return M
