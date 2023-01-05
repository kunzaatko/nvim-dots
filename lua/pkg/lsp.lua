local utils = require 'pkg.utils'
local M = {
  -- TODO: Add `nvim-window-picker` and `nvim-navic` <26-10-22>

  -- 'williamboman/mason.nvim' -- for installing LSPs, linters, formatters and other external
  -- applications {{{
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup {}
    end,
  },
  -- }}}

  -- 'williamboman/mason.nvim' -- for bridges mason and lspconfig to make them work together
  -- correctly {{{
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {}
    end,
  },
  -- }}}

  -- 'folke/trouble.nvim' -- diagnostics and quickfix-list {{{
  {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' },
    keys = utils.get_keys('n', { { '<leader>t' }, { 't', 'l', 'r', 'd' } }),
    setup = function()
      local wk = require 'which-key'
      wk.register({
        t = {
          name = 'Trouble',
          t = { 'Toggle' },
          l = { 'Lsp document diagnostics' },
          r = { 'Lsp references' },
          d = { 'Lsp definitions' },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      -- Trouble 'global' (full workspace diagnostics)
      map('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>', { silent = true, desc = 'toggle Trouble listing' })
      map(
        'n',
        '<Leader>tl',
        '<Cmd>TroubleToggle document_diagnostics<CR>',
        { silent = true, desc = 'toggle Trouble diagnostics listing' }
      ) -- Trouble 'local' (only the current buffer)
      map(
        'n',
        '<Leader>tr',
        '<Cmd>TroubleToggle lsp_references<CR>',
        { silent = true, desc = 'toggle Trouble LSP-references listing' }
      ) -- Trouble references
      map(
        'n',
        '<Leader>td',
        '<Cmd>TroubleToggle lsp_definitions<CR>',
        { silent = true, desc = 'toggle Trouble LSP-definitions listing' }
      ) -- Trouble definitions
    end,
  },
  -- }}}

  -- TODO: Consider fuzzy-path source and add path source into normal insert mode <12-03-22, kunzaatko> --
  -- TODO: Better colours in menu <16-01-22, kunzaatko> --
  -- 'hrsh7th/nvim-cmp' -- completion engine {{{
  {
    'hrsh7th/nvim-cmp',
    as = 'cmp',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'onsails/lspkind.nvim' },
      { 'hrsh7th/cmp-cmdline' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim' },
      { 'kdheepak/cmp-latex-symbols' },
      { 'lukas-reineke/cmp-rg' },
      { 'f3fora/cmp-spell' },
      { 'tzachar/cmp-tabnine', run = './install.sh' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'neovim/nvim-lspconfig' },
    },
    config = function()
      require 'conf.pkgs.nvim_cmp'
    end,
  },
  -- }}}

  -- 'nvim-treesitter/nvim-treesitter' -- treesitter code parsing and refactoring {{{
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    -- event = 'BufEnter',
    module = 'nvim-treesitter',
    -- cmd = {
    --   'TSInstall',
    --   'TSInstallInfo',
    --   'TSInstallSync',
    --   'TSUninstall',
    --   'TSUpdate',
    --   'TSUpdateSync',
    --   'TSDisableAll',
    --   'TSEnableAll',
    -- },
    config = function()
      require 'configs.treesitter'
    end,
  },
  -- }}}

  -- TODO: Configure <kunzaatko martinkunz@email.cz>
  -- 'mfussenegger/nvim-dap' -- debugger adapter protocol client {{{
  { 'mfussenegger/nvim-dap' },
  -- }}}

  -- 'github/copilot.vim' -- AI for coding generation {{{
  { 'github/copilot.vim' },
  -- }}}

  -- navigation objects from treesitter
  { 'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter' },

  -- TODO: consider using this in other filetypes than LaTeX <15-03-22, kunzaatko> --
  -- colour paired delimiters
  { 'p00f/nvim-ts-rainbow', requires = 'nvim-treesitter' },

  -- 'nvim-treesitter/playground' -- see the treesitter tree live {{{
  {
    'nvim-treesitter/playground',
    setup = function()
      local wk = require 'which-key'
      wk.register({ C = { 'Highlight captures' } }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      map(
        'n',
        '<leader>C',
        '<Cmd>TSHighlightCapturesUnderCursor<CR>',
        { silent = true, desc = 'show highlight capture under cursor' }
      )
    end,
    requires = 'nvim-treesitter',
  },
  -- }}}

  -- TODO: Do not show if it is only gitsigns code action (it is everywhere) (null-ls blame-line)
  -- <16-01-22, kunzaatko> --
  -- 'kosayoda/nvim-lightbulb' -- code action discovery {{{
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup {
        sign = { enabled = true, priority = 10 },
      }
      vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'DiagnosticInfo' }) -- 
      vim.api.nvim_create_autocmd({ 'CursorHoldI', 'CursorHold' }, {
        pattern = '*',
        desc = 'Show lightbulb the line',
        callback = function()
          -- TODO: Only want to ignore the `gitsigns` <02-03-22, kunzaatko> --
          require('nvim-lightbulb').update_lightbulb { ignore = { 'null-ls' } }
        end,
        group = vim.api.nvim_create_augroup('NvimLightbulb', {}),
      })
    end,
  },
  -- }}}

  { 'ray-x/lsp_signature.nvim' },

  -- development environment for lua and nvim
  { 'folke/neodev.nvim', as = 'neodev' },

  -- Scratchpad/REPL for lua in nvim
  { 'rafcamlet/nvim-luapad', requires = 'antoinemadec/FixCursorHold.nvim' },

  -- TODO: Use plugin lukas-reineke / lsp-format.nvim instead <kunzaatko martinkunz@email.cz>
  -- TODO: Add configuration files for different sources, and disable the diagnostics and features
  -- that are duplicated across many sources --
  -- 'jose-elias-alvarez/null-ls.nvim' -- for attaching command line utilities to nvim LSP client api {{{
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require 'null-ls'
      require 'utils.lsputils'
      require('null-ls').setup {
        on_attach = _G.LSPUtils.on_attach,
        sources = {
          null_ls.builtins.formatting.clang_format, -- C
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.formatting.prettier,
          -- null_ls.builtins.diagnostics.chktex,
          null_ls.builtins.formatting.yapf, -- Python
          -- null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.diagnostics.vale,
          null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.stylua.with {
          --   extra_args = { '--config-path', vim.fn.expand '~/.config/stylua.toml' },
          -- },
          null_ls.builtins.formatting.taplo, -- TOML
          null_ls.builtins.formatting.reorder_python_imports,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.formatting.shellharden,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.diagnostics.cppcheck,
          -- TODO: Add custom configuration file <22-08-22, kunzaatko>
          -- null_ls.builtins.diagnostics.commitlint.with {
          --   extra_args = { '--config', '~/.config/commitlint/config/index.js' },
          -- },
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.diagnostics.fish,
          -- null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.misspell,
          -- TODO: Generate standard library for selene for neovim <22-08-22>
          -- null_ls.builtins.diagnostics.selene,

          null_ls.builtins.diagnostics.proselint,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.stylelint,
          -- null_ls.builtins.diagnostics.write_good,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.hover.dictionary,
        },
      }
      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      -- FIX: Julia bug julia-vscode/julia-vscode#2526 crashes the server -> Julia cannot be
      -- autoformatted <19-02-22, kunzaatko> --
      vim.api.nvim_create_augroup('FormatOnSave', {})
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.lua', '*.py', '*.toml', '*.fish' },
        desc = 'Format filetypes of save',
        group = 'FormatOnSave',
        callback = function()
          vim.lsp.buf.format { async = false, name = 'null-ls' }
        end,
      })
    end,
    requires = { 'nvim-lua/plenary.nvim' },
  },
  -- }}}
}

return M
