-- FIX: Probably duplicate mapping for `S` in visual. I would like to have it surround but instead it triggers
-- `flash.nvim` <13-07-24>
-- TODO: `which-key` now supports icons. I should use them on in the mappings instead of using my own `string.format`
-- <13-07-24>
-- TODO: Every command for a specific language should be as a duplicate prepended with the language name for ease of
-- remembrance. That way if I want to execute a command that I know I have for a given language, I only need to write
-- the language and do not need to remember what it was. Also if I want to explore, which commands I have available.
-- <03-06-24, kunzaatko>
-- TODO: Plugins to add: 'hydra.nvim','neotest', 'instant.nvim', 'nvim-bqf'
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

vim.g.mapleader = ','
vim.g.maplocalleader = '-'

-- FIX: The default keymap of opening the terminal in the plugin directory launches a floating terminal and does not
-- work very well. Could I use the terminat.nvim plugin for it instead? <21-09-24>
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
  rocks = { hererocks = true },
  checker = {
    enabled = true,
    frequency = 3600 * 24, -- NOTE: Check once per day <03-09-24>
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
