return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
      },
      {
        'S',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
      },
    },
  },
  {
    'stevearc/oil.nvim',
    opts = {
      columns = { 'size', 'permissions', 'mtime', { 'icon', add_padding = false } },
      keymaps = { ['_'] = 'actions.parent' },
    },
    lazy = false,
    keys = '_',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
      vim.keymap.set('n', '_', require('oil').open, { desc = 'Open parent directory' })
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('OilOptions', { clear = true }),
        pattern = 'oil',
        callback = function()
          vim.opt_local.colorcolumn = { 0 }
        end,
      })
      require('oil').setup(opts)
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    keys = {
      '<leader><M-h>',
      '<leader><M-j>',
      '<leader><M-k>',
      '<leader><M-l>',
      '<M-h>',
      '<M-j>',
      '<M-k>',
      '<M-l>',
      '<M-Up>',
      '<M-Down>',
      '<M-Left>',
      '<M-Right>',
    },
    opts = { ignored_filetypes = { 'nofile', 'quickfix', 'qf', 'prompt' }, ignored_buftypes = { 'nofile' } },
    config = function(_, opts)
      require('smart-splits').setup(opts)
      vim.keymap.set('n', '<M-h>', require('smart-splits').move_cursor_left, { desc = 'move to left split' })
      vim.keymap.set('n', '<M-j>', require('smart-splits').move_cursor_down, { desc = 'move to below split' })
      vim.keymap.set('n', '<M-k>', require('smart-splits').move_cursor_up, { desc = 'move to above split' })
      vim.keymap.set('n', '<M-l>', require('smart-splits').move_cursor_right, { desc = 'move to right split' })
      vim.keymap.set('n', '<M-Up>', require('smart-splits').resize_up, { desc = 'resize split up' })
      vim.keymap.set('n', '<M-Down>', require('smart-splits').resize_down, { desc = 'resize split down' })
      vim.keymap.set('n', '<M-Left>', require('smart-splits').resize_left, { desc = 'resize split left' })
      vim.keymap.set('n', '<M-Right>', require('smart-splits').resize_right, { desc = 'resize split right' })
      vim.keymap.set('n', '<leader><M-h>', require('smart-splits').swap_buf_left, { desc = 'swap split left' })
      vim.keymap.set('n', '<leader><M-j>', require('smart-splits').swap_buf_down, { desc = 'swap split down' })
      vim.keymap.set('n', '<leader><M-k>', require('smart-splits').swap_buf_up, { desc = 'swap split up' })
      vim.keymap.set('n', '<leader><M-l>', require('smart-splits').swap_buf_right, { desc = 'swap split right' })
    end,
  },
  {
    'folke/which-key.nvim',
    -- commit = '8649bf5c66b8fa1fa6ee879b9af78e89f886d13c',
    opts = {
      preset = 'helix',
      icons = { group = '', separator = '' },
      disable = { ft = { 'TelescopePrompt' } },
      spelling = {
        enabled = true,
        suggestions = 10,
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    config = function(_, opts)
      vim.opt.timeout = true
      vim.opt.timeoutlen = 500
      require('which-key').setup(opts)
    end,
  },
  {
    'windwp/nvim-autopairs',
    name = 'autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0,
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
      },
    },
    config = function(_, opts)
      local npairs = require 'nvim-autopairs'
      local Rule = require 'nvim-autopairs.rule'
      local cond = require 'nvim-autopairs.conds'

      npairs.setup(opts)

      npairs.get_rules("'")[1]:with_pair(cond.not_filetypes { 'tex', 'latex', 'typst' }) -- derivatives
      npairs.add_rules {
        Rule('$', '$', { 'tex', 'latex', 'typst' }),
      }

      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  -- TODO: Get inspiration from this for the LaTeX frac snippet <15-06-23>
  {
    'utilyre/sentiment.nvim',
    event = 'VeryLazy',
    config = true,
    init = function()
      vim.g.loaded_matchparen = 1 -- needs to be here for lazy loading
    end,
  },
  {
    'numToStr/Comment.nvim',
    name = 'Comment',
    keys = { { 'gb', mode = 'v' }, { 'gc', mode = 'v' }, 'gcc', 'gc', 'gco', 'gcO', 'gcA', 'gb', 'gbc' },
    config = true,
  },
  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
  },
  {
    'NMAC427/guess-indent.nvim',
    event = 'BufReadPost',
    config = true,
  },
  {
    'kylechui/nvim-surround',
    name = 'surround',
    keys = { 'ys', 'ds', 'cs', { 'S', mode = 'v' } },
    config = function()
      require('nvim-surround').setup { mappings_style = 'surround' }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = true,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', name = 'treesitter-textobjects' },
    },
    name = 'treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
    config = function()
      local treesitter = require 'nvim-treesitter.configs'
      ---@diagnostic disable-next-line: missing-fields
      treesitter.setup {
        -- stylua: ignore start
        ensure_installed = {
          'bash', 'bibtex', 'gitcommit', 'gitignore', 'c', 'cpp', 'css', 'fish', 'go', 'html', 'htmldjango', 'json',
          'julia', 'latex', 'lua', 'sql', 'r', 'ron', 'diff', 'scss', 'norg', 'python', 'query', 'rust', 'toml',
          'typst', 'vim', 'yaml', 'markdown', 'markdown_inline',
        },
        -- stylua: ignore end
        highlight = {
          enable = true,
          -- FIX: Disabled at the moment due to some issue with patterns "Impossible Pattern". On markdown treesitter
          -- parser update it can be enabled again <30-04-24>
          disable = { 'latex', 'tex', 'vim', 'markdown' },
          additional_vim_regex_highlighting = { 'markdown' },
        },
        indent = { enable = true },
        textobjects = {
          select = {
            disable = { 'tex', 'latex' },
            enable = true,
            lookahead = true,
            keymaps = {
              -- TODO: Add more textobjects <12-01-23>
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['ad'] = {
                desc = 'Select around an entire docstring',
                query = '@string.documentation',
                query_group = 'highlights',
              },
            },
          },
        },
        incremental_selection = { enable = true },
      }
    end,
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    cmd = 'SessionLoad',
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'winpos', 'terminal' },
    },
    config = function()
      vim.api.nvim_create_user_command('SessionLoad', require('persistence').load, { nargs = 0 })
    end,
  },
  {
    'godlygeek/tabular',
    event = 'VeryLazy',
  },
}
