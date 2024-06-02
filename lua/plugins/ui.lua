return {
  {
    -- TODO: Add keymaps <10-01-23>
    'folke/trouble.nvim',
    name = 'trouble',
    event = 'VeryLazy',
    dependencies = { { 'kyazdani42/nvim-web-devicons', name = 'devicons' } },
    cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose', 'TroubleRefresh' },
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    event = 'VeryLazy',
    keys = { { '<leader>u' } },
    config = function()
      vim.g.undotree_WindowLayout = 2 -- layout with diff at the bottom
      vim.g.undotree_DiffpanelHeight = 7 -- most of the time only one line changes
      vim.g.undotree_ShortIndicators = 1 -- time indicators 's,m,h,d'
      vim.g.undotree_SplitWidth = 40 -- it fits 3 branches
      vim.g.undotree_TreeNodeShape = ''
      vim.g.undotree_TreeVertShape = '│'
      vim.g.undotree_DiffAutoOpen = 0 -- it does not carry much info
      vim.g.undotree_SetFocusWhenToggle = 1 -- better for using it for complicated undo and not informative
      vim.g.undotree_HelpLine = 0 -- do not show the help line hint

      vim.keymap.set('n', '<leader>U', '<Cmd>UndotreeToggle<CR>', { silent = true, desc = 'Undotree toggle' })
    end,
  },
  -- TODO: Use icon util <20-05-23>
  -- TODO: configure <20-05-23>
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = ' Apps',
              group = 'DiagnosticHint',
              action = 'Telescope app',
              key = 'a',
            },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
  -- TODO: Configure colours to be foreground <23-06-23>
  {
    'Bekaboo/dropbar.nvim',
    enabled = false,
    event = 'VeryLazy',
    config = true,
  },
  --  [[                                                                   ]],
  --  [[      ████ ██████           █████      ██                    ]],
  --  [[     ███████████             █████                            ]],
  --  [[     █████████ ███████████████████ ███   ███████████  ]],
  --  [[    █████████  ███    █████████████ █████ ██████████████  ]],
  --  [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
  --  [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
  --  [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
  {
    'goolord/alpha-nvim',
    enabled = false,
    config = function()
      require('alpha').setup(require('alpha.themes.dashboard').config)
    end,
  },
}
