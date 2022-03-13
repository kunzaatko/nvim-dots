local utils = require 'pkg.utils'
local M = {
  -- TODO: Better with 'dashboard.nvim' plugin? <16-01-22, kunzaatko> --
  -- 'mhinz/vim-startify'-- launch page{{{
  {
    'mhinz/vim-startify',
    as = 'startify',
    setup = function()
      vim.g.startify_fortune_use_unicode = 1
    end,
  },
  -- }}}

  -- 'mbbill/undotree' -- undotree visualizer {{{
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = utils.get_keys('n', '<leader>u'),
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
      local map = vim.keymap.set
      map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', { silent = true })
    end,
  },
  -- }}}

  -- 'folke/which-key.nvim' -- echo keymappings {{{
  {
    'folke/which-key.nvim',
    as = 'which_key',
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
    as = 'auto_session',
    config = function()
      require('auto-session').setup { auto_session_suppress_dirs = { '~/' } }
    end,
    requires = {
      {
        'rmagatti/session-lens',
        as = 'session_lens',
        setup = function()
          local wk = require 'which-key'
          wk.register({ fl = { 'Load session' } }, { prefix = '<leader>' })
        end,
        keys = utils.get_keys('n', '<leader>fl'),
        config = function()
          local map = vim.keymap.set
          require('session-lens').setup()
          map('n', '<leader>fl', function()
            return require('session-lens').search_session()
          end, { silent = true })
        end,
      },
    },
  },
  -- }}}
}

return M
