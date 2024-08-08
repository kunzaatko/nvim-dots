return {
  {
    'simrat39/rust-tools.nvim',
    name = 'rust-tools',
    ft = 'rust',
    dependencies = {
      'plenary',
      { 'nvim-telescope/telescope.nvim', name = 'telescope' },
      { 'neovim/nvim-lspconfig', name = 'lspconfig' },
    },
    opts = {
      server = {
        on_attach = function()
          local rt = require 'rust-tools'
          vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = true, desc = 'Hover actions' })
          vim.keymap.set(
            'n',
            '<localleader>a',
            rt.code_action_group.code_action_group,
            { buffer = true, desc = 'Code action' }
          )
          vim.keymap.set('n', '<localleader>r', rt.runnables.runnables, { buffer = true, desc = 'Rust runnables' })
          vim.keymap.set(
            'n',
            '<localleader>ct',
            rt.open_cargo_toml.open_cargo_toml,
            { buffer = true, desc = 'Open cargo.toml' }
          )
          vim.keymap.set(
            'n',
            '<localleader>g',
            rt.crate_graph.view_crate_graph,
            { buffer = true, desc = 'Crate graph' }
          )
        end,
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy',
          },
        },
      },
    },
  },
  {
    'saecki/crates.nvim',
    event = { 'BufReadPre Cargo.toml' },
    dependencies = {
      'plenary',
    },
    opts = {
      lsp = {
        enabled = true,
        name = 'crates',
        actions = true,
        completion = true,
        hover = true,
      },
      completion = {
        crates = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      require('crates').setup(opts)
      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('Create crates keymaps', {}),
        pattern = 'Cargo.toml',
        callback = function()
          local crates = require 'crates'

          vim.keymap.set('n', '<localleader>t', crates.toggle, { buffer = true, desc = 'Toggle' })
          vim.keymap.set('n', '<localleader>r', crates.reload, { buffer = true, desc = 'Reload crates.nvim' })

          vim.keymap.set('n', '<localleader>v', crates.show_versions_popup, { buffer = true, desc = 'Versions' })
          vim.keymap.set('n', '<localleader>f', crates.show_features_popup, { buffer = true, desc = 'Features' })
          vim.keymap.set(
            'n',
            '<localleader>d',
            crates.show_dependencies_popup,
            { buffer = true, desc = 'Dependencies' }
          )

          vim.keymap.set('n', '<localleader>u', crates.update_crate, { buffer = true, desc = 'Update crate' })
          vim.keymap.set('v', '<localleader>u', crates.update_crates, { buffer = true, desc = 'Update' })
          vim.keymap.set('n', '<localleader>a', crates.update_all_crates, { buffer = true, desc = 'Update all' })
          vim.keymap.set('n', '<localleader>U', crates.upgrade_crate, { buffer = true, desc = 'Upgrade crate' })
          vim.keymap.set('v', '<localleader>U', crates.upgrade_crates, { buffer = true, desc = 'Upgrade' })
          vim.keymap.set('n', '<localleader>A', crates.upgrade_all_crates, { buffer = true, desc = 'Upgrade all' })

          vim.keymap.set('n', '<localleader>H', crates.open_homepage, { buffer = true, desc = 'Homepage' })
          vim.keymap.set('n', '<localleader>R', crates.open_repository, { buffer = true, desc = 'Repo' })
          vim.keymap.set('n', '<localleader>D', crates.open_documentation, { buffer = true, desc = 'Documentation' })
          vim.keymap.set('n', '<localleader>C', crates.open_crates_io, { buffer = true, desc = 'Crates.io' })
        end,
      })
    end,
  },
}
