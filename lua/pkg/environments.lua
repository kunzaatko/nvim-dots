local M = {
  -- TODO: Close with `q` <16-01-22, kunzaatko> --
  -- 'dstein64/vim-startuptime' -- profiling for start-up time and plug-in loading {{{
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    setup = 'vim.g.startuptime_tries = 10',
  },
  -- }}}

  -- TODO: Setup <16-01-22, kunzaatko> --
  -- 'glacambre/firenvim' -- extension for browser insert boxes to use nvim {{{

  {
    'glacambre/firenvim',
    opt = true,
    run = function()
      vim.fn['firenvim#install'](0)
    end,
    cond = function()
      return vim.fn.exists 'g:started_by_firenvim'
    end,
  },
  -- }}}

  -- TODO: Setup <16-01-22, kunzaatko> --
  -- 'vhyrro/neorg' -- main package for norg format {{{
  {
    'vhyrro/neorg',
    branch = 'main',
    config = function()
      require 'conf.pkgs.neorg'
    end,
  },
  -- }}}
}

return M
