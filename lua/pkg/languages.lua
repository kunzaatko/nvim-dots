local M = {
  -- TODO: Set better on_attach <kunzaatko martinkunz@email.cz>
  -- 'simrat39/rust-tools.nvim' -- LSP rust specifics {{{
  {
    'simrat39/rust-tools.nvim',
    as = 'rust_tools',
    ft = 'rust',
    config = function()
      local rt = require 'rust-tools'

      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
            vim.keymap.set('n', '<LocalLeader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
            vim.keymap.set('n', '<LocalLeader>r', rt.runnables.runnables, { buffer = bufnr })
            vim.keymap.set('n', '<LocalLeader>c', rt.open_cargo_toml.open_cargo_toml, { buffer = bufnr })
            vim.keymap.set('n', '<LocalLeader>g', rt.crate_graph.view_crate_graph, { buffer = bufnr })
          end,
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy',
            },
          },
        },
      }
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'neovim/nvim-lspconfig',
    },
  },
  -- }}}

  -- 'saecki/crates.nvim -- for editting cargo.toml file {{{
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    requires = { 'nvim-lua/plenary.nvim', 'jose-elias-alvarez/null-ls.nvim' },
    config = function()
      require('crates').setup {
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
      }

      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('Create crates keymaps', {}),
        pattern = 'Cargo.toml',
        callback = function()
          local crates = require 'crates'
          local opts = { noremap = true, silent = true, buffer = true }

          vim.keymap.set('n', '<localleader>t', crates.toggle, opts)
          vim.keymap.set('n', '<localleader>r', crates.reload, opts)

          vim.keymap.set('n', '<localleader>v', crates.show_versions_popup, opts)
          vim.keymap.set('n', '<localleader>f', crates.show_features_popup, opts)
          vim.keymap.set('n', '<localleader>d', crates.show_dependencies_popup, opts)

          vim.keymap.set('n', '<localleader>u', crates.update_crate, opts)
          vim.keymap.set('v', '<localleader>u', crates.update_crates, opts)
          vim.keymap.set('n', '<localleader>a', crates.update_all_crates, opts)
          vim.keymap.set('n', '<localleader>U', crates.upgrade_crate, opts)
          vim.keymap.set('v', '<localleader>U', crates.upgrade_crates, opts)
          vim.keymap.set('n', '<localleader>A', crates.upgrade_all_crates, opts)

          vim.keymap.set('n', '<localleader>H', crates.open_homepage, opts)
          vim.keymap.set('n', '<localleader>R', crates.open_repository, opts)
          vim.keymap.set('n', '<localleader>D', crates.open_documentation, opts)
          vim.keymap.set('n', '<localleader>C', crates.open_crates_io, opts)
        end,
      })
    end,
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

  -- yuck language support
  { 'elkowar/yuck.vim', as = 'yuck' },
}

return M
