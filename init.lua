-- TODO: Plugins to add: 'hydra.nvim','neotest', 'paint.nvim', 'modicator.nvim', 'instant.nvim', 'nvim-bqf'
-- TODO: Should use some option or plugin to make the insertmode respect the `linelength` even when something else is
-- behind the cursor... <18-04-23>
-- TODO: Add a README and start versioning the configuration <19-04-23>

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
require 'static'

vim.g.mapleader = ' '
vim.g.maplocalleader = '-'

require('lazy').setup({
  { -- NOTE: For debugging and independent plug-in testing <18-01-24>
    'abeldekat/lazyflex.nvim',
    version = '*',
    cond = false,
    import = 'lazyflex.hook',
    opts = {
      kw = {
        'blankline',
      },
      enable_match = false,
    },
  },
  { import = 'plugins' },
  { import = 'plugins.languages' },
  { import = 'plugins.fun' },
}, {
  checker = {
    enabled = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  defaults = {
    lazy = true,
  },
  diff = {
    cmd = 'diffview.nvim',
  },
})

-- NOTE: Config must be loaded after lazy setting up to be able to use module plug-ins
require 'config'

vim.cmd [[colorscheme nord]]
