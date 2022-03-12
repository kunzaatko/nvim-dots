local utils = require 'pkg.utils'
local M = {
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
      -- Trouble 'global' (full workspace diagnostics)
      vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>TroubleToggle<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        'n',
        '<Leader>tl',
        '<Cmd>TroubleToggle document_diagnostics<CR>',
        { noremap = true, silent = true }
      ) -- Trouble 'local' (only the current buffer)
      vim.api.nvim_set_keymap(
        'n',
        '<Leader>tr',
        '<Cmd>TroubleToggle lsp_references<CR>',
        { noremap = true, silent = true }
      ) -- Trouble references
      vim.api.nvim_set_keymap(
        'n',
        '<Leader>td',
        '<Cmd>TroubleToggle lsp_definitions<CR>',
        { noremap = true, silent = true }
      ) -- Trouble definitions
    end,
  },
  -- }}}

  -- TODO: Show snippets first in sorted <16-01-22, kunzaatko> --
  -- TODO: Better colours in menu <16-01-22, kunzaatko> --
  -- 'hrsh7th/nvim-cmp' -- completion engine {{{
  {
    'hrsh7th/nvim-cmp',
    as = 'cmp',
    requires = {
      { 'hrsh7th/cmp-buffer' },
      -- FIX: How to do this better? <16-01-22, kunzaatko> --
      {
        'nvim-lua/lsp-status.nvim',
        config = function()
          require('lsp-status').config {
            show_filename = false,
            current_function = false,
            diagnostics = false,
            status_symbol = '',
            spinner_frames = { '◓', '◑', '◒', '◐' },
          }
        end,
      },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'quangnguyen30192/cmp-nvim-ultisnips', after = 'cmp' },
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
    config = function()
      require 'conf.pkgs.treesitter'
    end,
  },
  -- }}}

  -- navigation objects from treesitter
  { 'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter' },

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
      vim.api.nvim_set_keymap(
        'n',
        '<leader>C',
        '<Cmd>TSHighlightCapturesUnderCursor<CR>',
        { silent = true, noremap = true }
      )
    end,
    requires = 'nvim-treesitter',
  },
  -- }}}

  -- TODO: Is this needed anymore? <16-01-22, kunzaatko> --
  -- 'nvim-lua/lsp_extensions' -- rust type annotations {{{
  {
    'nvim-lua/lsp_extensions.nvim',
    ft = 'rust',
    config = function()
      require('lsp_extensions').inlay_hints()
      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      --luacheck: no max line length
      vim.cmd [[
                augroup RustTypeHints
                    autocmd!
                    autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }
                augroup END
        ]]
      --luacheck: max line length 120
    end,
  },
  -- }}}

  -- TODO: Do not show if it is only gitsigns code action (it is everywhere) (null-ls blame-line)
  -- <16-01-22, kunzaatko> --
  -- 'kosayoda/nvim-lightbulb' -- code action discovery {{{
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup {
        -- FIX: Only want to ignore the `gitsigns` <02-03-22, kunzaatko> --
        -- FIX: This is not working <02-03-22, kunzaatko> --
        ignore = { 'null-ls' },
        sign = { enabled = true, priority = 10 },
        float = { enabled = true, text = ' ' },
        virtual_text = { enabled = true, text = ' ', hl_mode = 'replace' },
        status_text = { enabled = true, text = ' ', text_unavailable = '' },
      }
      vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'DiagnosticInfo' }) -- 
      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      --luacheck: no max line length
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb({ignore = {"null-ls"}})]]
      --luacheck: max line length 120
    end,
  },
  -- }}}

  -- development environment for lua and nvim
  { 'folke/lua-dev.nvim', as = 'lua-dev' },

  -- 'lewis6991/spellsitter.nvim' -- use the inbuilt neovim spellchecker with treesitter {{{
  {
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup { spellchecker = 'vimfn' }
    end,
  },
  -- }}}

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
          null_ls.builtins.diagnostics.chktex,
          null_ls.builtins.formatting.yapf, -- Python
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.diagnostics.vale,
          null_ls.builtins.formatting.stylua.with {
            extra_args = { '--config-path', vim.fn.expand '~/.config/stylua.toml' },
          },
          null_ls.builtins.formatting.taplo, -- TOML
          null_ls.builtins.formatting.reorder_python_imports,
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.formatting.shellharden,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.diagnostics.cppcheck,
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.misspell,
          -- null_ls.builtins.diagnostics.proselint,
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
      vim.cmd [[
            augroup FormatAutogroup
                autocmd!
                autocmd! BufWritePre *.rs,*.lua,*.py,*.toml,*.tex,*.fish lua vim.lsp.buf.formatting_sync()
            augroup END
                ]]
    end,
    requires = { 'nvim-lua/plenary.nvim' },
  },
  -- }}}
}

return M
