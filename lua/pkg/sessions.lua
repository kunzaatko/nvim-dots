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
    cond = false,
  },
  -- }}}

  -- │╭───────────────────────────────────────────────────╮
  -- ││ Provide options, don't make lame excuses.         │
  -- ││                                                   │
  -- ││ Instead of excuses, provide options. Don't say it │
  -- ││ can't be done; explain what can be done.          │
  -- │╰───────────────────────────────────────────────────╯
  -- │ │ │ │ o
  -- │ │ │ │ │o   ^__^
  -- │ │ │ │ │ o  (oo)\_______
  -- │ │ │ │ │ │ │(__)\       )\/\
  -- │ │ │ │ │ │ │ │ │||----w |
  -- │ │ │ │ │ │ │ │ │||     ||

  {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local startify = require 'alpha.themes.startify'
      require 'alpha.term'

      startify.nvim_web_devicons.enabled = false
      local config = {
        layout = {
          { type = 'padding', val = 2 },
          {
            type = 'text',
            val = function()
              return _G.AlphaFortune
            end,
            opts = { position = 'center', hl = 'Delimiter' },
          },
          { type = 'padding', val = 2 },
          startify.section.top_buttons,
          startify.section.mru_cwd,
          startify.section.mru,
          { type = 'padding', val = 1 },
          startify.section.bottom_buttons,
          startify.section.footer,
        },
        opts = {
          margin = 3,
          setup = function()
            _G.AlphaFortune = vim.split(vim.fn.system('fortune discworld | cowsay', ''), '\n', { plain = true })
            vim.api.nvim_create_autocmd('DirChanged', {
              group = vim.api.nvim_create_augroup('Alpha', {}),
              pattern = '*',
              callback = function()
                alpha.redraw()
              end,
            })
          end,
        },
      }
      require 'alpha.term'

      require('alpha').setup(config)
    end,
  },

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
      map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', { silent = true, desc = 'toggle UndoTree' })
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
      require('auto-session').setup {
        auto_session_suppress_dirs = { '~/' },
        auto_session_enabled = false,
      }
    end,
    requires = {
      {
        'rmagatti/session-lens',
        as = 'session_lens',
        setup = function()
          local wk = require 'which-key'
          wk.register({ fS = { 'Load session' } }, { prefix = '<leader>' })
        end,
        keys = utils.get_keys('n', '<leader>fS'),
        config = function()
          local map = vim.keymap.set
          require('session-lens').setup()
          map('n', '<leader>fS', function()
            return require('session-lens').search_session()
          end, { silent = true, desc = 'list sessions' })
        end,
      },
    },
  },
  -- }}}
}

return M
