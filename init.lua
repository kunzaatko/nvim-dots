-- TODO: `which-key` now supports icons. I should use them on in the mappings instead of using my own `string.format`
-- <13-07-24>
-- TODO: Every command for a specific language should be as a duplicate prepended with the language name for ease of
-- remembrance. That way if I want to execute a command that I know I have for a given language, I only need to write
-- the language and do not need to remember what it was. Also if I want to explore, which commands I have available.
-- <03-06-24, kunzaatko>
-- TODO: Plugins to add: 'hydra.nvim','neotest', 'instant.nvim', 'nvim-bqf'
-- TODO: Add a README and start versioning the configuration <19-04-23>

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
-- work very well. Could I use the terminal.nvim plugin for it instead? <21-09-24>
require('lazy').setup({
  { import = 'plugins' },
  { import = 'plugins.languages' },
  { import = 'plugins.fun' },
}, {
  rocks = { hererocks = true },
  checker = {
    enabled = true,
    frequency = 3600 * 24 * 7, -- check for updates once per week
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

-- config must be loaded after lazy setting up to be able to use module plug-ins
require 'config'

if vim.version().minor >= 11 then
  -- FIX: Does not work for the LSP servers that are defined manually in the `lsp/` runtime <11-03-2026>
  -- NOTE: Use `.git` as a marker for every LS
  vim.lsp.config('*', { root_markers = { '.git' } })

  local enabled_servers = {}

  -- conditionally enabled servers
  for server_name, command in pairs {
    bashls = 'bash-language-server',
    ccls = 'ccls',
    cssls = 'css-languageserver',
    fish_lsp = 'fish-lsp',
    -- harper_ls = 'harper-ls',
    html = 'html-languageserver',
    just = 'just-lsp',
    kotlin_language_server = 'kotlin-language-server',
    terraformls = 'terraform-ls',
    texlab = 'texlab',
    ts_ls = 'typescript-language-server',
    yamlls = 'yaml-language-server',
  } do
    if vim.fn.executable(command) == 1 then
      table.insert(enabled_servers, server_name)
    end
  end

  -- always enabled servers
  enabled_servers = vim.list_extend(enabled_servers, {
    'jsonls',
    'julials',
    'lua_ls',
    'ruff',
    'taplo',
    'ty',
    -- 'pyright',
  })

  -- NOTE: Must be loaded after `lazy` for plugins to specify the necessary capabilities and `on_attach` functions
  vim.lsp.enable(enabled_servers)
end

---@type boolean
local colourscheme_loaded
if vim.env['THEME_COLOUR'] == "'prefer-light'" then
  ---@diagnostic disable-next-line: param-type-mismatch
  colourscheme_loaded = pcall(vim.cmd, [[colorscheme dayfox]])
else
  ---@diagnostic disable-next-line: param-type-mismatch
  colourscheme_loaded = pcall(vim.cmd, [[colorscheme catppuccin-frappe]])
end

if not colourscheme_loaded then
  vim.cmd [[colorscheme default]]
end
