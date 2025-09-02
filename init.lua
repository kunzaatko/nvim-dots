-- FIX: Probably duplicate mapping for `S` in visual. I would like to have it surround but instead it triggers
-- `flash.nvim` <13-07-24>
-- TODO: `which-key` now supports icons. I should use them on in the mappings instead of using my own `string.format`
-- <13-07-24>
-- TODO: Every command for a specific language should be as a duplicate prepended with the language name for ease of
-- remembrance. That way if I want to execute a command that I know I have for a given language, I only need to write
-- the language and do not need to remember what it was. Also if I want to explore, which commands I have available.
-- <03-06-24, kunzaatko>
-- TODO: Plugins to add: 'hydra.nvim','neotest', 'instant.nvim', 'nvim-bqf'
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
  { import = 'plugins' },
  { import = 'plugins.languages' },
  { import = 'plugins.fun' },
}, {
  rocks = { hererocks = true },
  checker = {
    enabled = true,
    frequency = 3600 * 24, -- check for updates once per day
  },
  ui = {
    custom_keys = {
      ['gf'] = {
        function(plugin)
          vim.cmd('tabnew ' .. plugin.dir)
        end,
        desc = 'Open tab with the plugin directory',
      },
    },
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

-- TODO: I am not able to set the diagnostic config only for the given buffer. How do I do that? <05-06-25>
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'lazy',
--   callback = function()
--     vim.notify 'Lazy autocommand'
--     local ns = vim.api.nvim_create_namespace 'Lazy diagnostics'
--     vim.diagnostic.config({
--       virutal_text = true,
--     }, ns)
--   end,
--   desc = 'Show diagnostics on all lines in `lazy` buffer for the breaking changes annotations',
-- })

-- config must be loaded after lazy setting up to be able to use module plug-ins
require 'config'

if vim.version().minor >= 11 then
  -- NOTE: Use `.git` as a marker for every LS
  vim.lsp.config('*', { root_markers = { '.git' }, capabilities = require('util.lsp').get_capabilities() })
  -- NOTE: Must be loaded after `lazy` for plugins to specify the necessary capabilities and `on_attach` functions
  vim.lsp.enable {
    'julials',
    'texlab',
    'lua_ls',
    'taplo',
    'ccls',
    'ruff',
    'pyright',
    'jsonln',
    'kotlin_language_server',
    'html',
    'bashls',
    'harper_ls',
  }
end

---@type boolean
local colourscheme_loaded
if vim.env['THEME_COLOUR'] == "'prefer-light'" then
  colourscheme_loaded = pcall(vim.cmd, [[colorscheme dayfox]])
else
  colourscheme_loaded = pcall(vim.cmd, [[colorscheme terafox]])
end

if not colourscheme_loaded then
  vim.cmd [[colorscheme default]]
end
