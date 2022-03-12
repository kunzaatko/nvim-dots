local M = {
  -- TODO: Better with 'dashboard.nvim' plugin? <16-01-22, kunzaatko> --
  -- 'mhinz/vim-startify'-- launch page{{{
  {
    'mhinz/vim-startify',
    setup = function()
      vim.g.startify_fortune_use_unicode = 1
    end,
  },
  -- }}}

  -- 'mbbill/undotree' -- undotree visualizer {{{
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { 'n', '<leader>u' },
    setup = function()
      vim.g.undotree_WindowLayout = 2 -- layout with diff at the bottom
      vim.g.undotree_DiffpanelHeight = 7 -- most of the time only one line changes
      vim.g.undotree_ShortIndicators = 1 -- time indicators 's,m,h,d'
      vim.g.undotree_SplitWidth = 40 -- it fits 3 branches
      vim.g.undotree_TreeNodeShape = ''
      vim.g.undotree_TreeVertShape = '│'
      vim.g.undotree_DiffAutoOpen = 0 -- it does not carry much info
      vim.g.undotree_SetFocusWhenToggle = 1 -- better for using it for complicated undo and not informative
      vim.g.undotree_HelpLine = 0 -- do not show the help line hint
      local wk = require 'which-key'
      wk.register({ u = {
        'UndoTree toggle',
      } }, { prefix = '<leader>' })
    end,
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', { noremap = true, silent = true })
    end,
  },
  -- }}}

  -- 'folke/which-key.nvim' -- echo keymappings {{{
  {
    'folke/which-key.nvim',
    config = function()
      -- TODO: configure https://github.com/folke/which-key.nvim <28-04-21, kunzaatko> --
      require('which-key').setup {
        plugins = { spelling = { enabled = true } },
        window = { border = 'double', margin = { 0, 0, 0, 0 } },
        ignore_missing = true,
      }
    end,
  },
  -- }}}

  -- TODO: Session loading notification using notify <16-01-22, kunzaatko> --
  -- TODO: Does not work when packer (maybe others too) <16-01-22, kunzaatko> --
  -- TODO: Extremely slow plugin. Can it do better? <16-01-22, kunzaatko> --
  -- TODO: SaveSession should save to session directory <16-01-22, kunzaatko> --
  -- 'rmagatti/auto-session' -- automatically store sessions for cwd {{{
  {
    'rmagatti/auto-session',
    config = function()
      require('auto-session').setup { auto_session_suppress_dirs = { '~/' } }
    end,
    requires = {
      {
        'rmagatti/session-lens',
        setup = function()
          local wk = require 'which-key'
          wk.register({ fl = { 'Load session' } }, { prefix = '<leader>' })
        end,
        keys = '<leader>fl',
        config = function()
          require('session-lens').setup()
          vim.api.nvim_set_keymap(
            'n',
            '<leader>fl',
            "<Cmd>lua require('session-lens').search_session()<CR>",
            { noremap = true, silent = true }
          )
        end,
      },
    },
  },
  -- }}}
}

return M
