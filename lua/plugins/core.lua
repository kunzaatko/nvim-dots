return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    ---@diagnostic disable-next-line: missing-fields
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
    dependencies = { { 'nvim-tree/nvim-web-devicons', name = 'devicons' } },
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

      -- TODO: Is this still needed for blink.nvim... It has auto-delimiters <14-12-24>
      -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      -- local cmp = require 'cmp'
      -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
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
    -- TODO: Add keymap for surrounding in visual mode. The current `S` does not work... <30-03-25>
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
          disable = { 'latex', 'tex' }, -- , 'vim', 'markdown' },
          -- additional_vim_regex_highlighting = { 'markdown' },
        },
        indent = { enable = true },
        textobjects = {
          select = {
            -- BUG: error no "function_expression" in julia parser <17-11-24>
            disable = { 'tex', 'latex', 'julia' },
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
    'olimorris/persisted.nvim',
    lazy = false,
    config = true,
  },
  {
    'folke/persistence.nvim',
    enabled = false,
    event = 'BufReadPre',
    cmd = 'SessionLoad',
    opts = {
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'winpos', 'terminal' },
    },
    config = function()
      vim.api.nvim_create_user_command('SessionLoad', require('persistence').load, { nargs = 0 })
    end,
  },
  -- TODO: Replace telescope picking with snacks <28-01-25>
  -- TODO: Use the `icon` utils for setting icons <30-03-25>
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      -- Top Pickers & Explorer
      {
        '<leader><space>',
        function()
          Snacks.picker.smart()
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>n',
        function()
          Snacks.picker.notifications()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },
      -- find
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Config File',
      },
      {
        'gđ',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Git Files',
      },
      {
        '<leader>fp',
        function()
          Snacks.picker.projects()
        end,
        desc = 'Projects',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent',
      },
      -- git
      {
        '<leader>gb',
        function()
          Snacks.picker.git_branches()
        end,
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gL',
        function()
          Snacks.picker.git_log_line()
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          Snacks.picker.git_stash()
        end,
        desc = 'Git Stash',
      },
      {
        '<leader>gd',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          Snacks.picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
      -- Grep
      {
        '//',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        'đ', -- Alt+s
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>s/',
        function()
          Snacks.picker.search_history()
        end,
        desc = 'Search History',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        desc = 'Autocmds',
      },
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>sC',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>si',
        function()
          Snacks.picker.icons()
        end,
        desc = 'Icons',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sp',
        function()
          Snacks.picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undo History',
      },
      {
        '<leader>uC',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
    opts = {
      bigfile = {},
      quickfile = {},
      notifier = {},
      statuscolumn = {},
      indent = {},
      input = {},
      -- scroll = {},
      words = {},
      ---@class snacks.picker.Config
      picker = {
        win = {
          input = {
            keys = {
              ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
              ['s'] = { 'flash' },
            },
          },
        },
        actions = {
          flash = function(picker)
            require('flash').jump {
              pattern = '^',
              label = { after = { 0, 0 } },
              search = {
                mode = 'search',
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            }
          end,
        },
      },
      -- TODO: Colours so that the headers have a better contrast colour <19-11-24>
      -- FIX: Projects do not work with persistence. Giving an error. <19-11-24>
      -- TODO: A dashboard shortcut for entering the `GpChat` <06-12-24>
      dashboard = {
        enabled = true,
        height = 0.9,
        width = 90,
        autokeys = 'asdfgweruiovncmpzxASDFGWERUIOVNCMPZX23457891',
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            --   { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = ' ',
              key = 'c',
              desc = 'Config',
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
          header = [[
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████]],
        },
        formats = {
          key = function(item)
            return { { '[', hl = 'special' }, { item.key, hl = 'key' }, { ']', hl = 'special' } }
          end,
        },
        sections = {
          { section = 'header' },
          { section = 'startup', padding = 1 },
          { section = 'keys', gap = 0, padding = 1 },
          {
            pane = 2,
            icon = static.icons.snippets,
            title = ' MRU',
            file = vim.fn.fnamemodify('.', ':~'),
            padding = 0,
          },
          { pane = 2, section = 'recent_files', cwd = true, limit = 8, padding = 1, indent = 2 },
          { pane = 2, icon = static.icons.snippets, title = 'MRU', padding = 0 },
          { pane = 2, section = 'recent_files', limit = 8, padding = 1, indent = 2 },
          {
            pane = 2,
            icon = static.icons.projects,
            title = 'Projects',
            section = 'projects',
            indent = 2,
            padding = 2,
          },
          {
            pane = 2,
            icon = static.icons.git.branch,
            title = 'Git Status',
            section = 'terminal',
            enabled = vim.fn.isdirectory '.git' == 1,
            cmd = 'git status --short --branch --renames',
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          {
            section = 'terminal',
            cmd = 'fortune -s | cowsay -w -T U',
            hl = 'header',
            padding = 1,
            indent = 20,
            width = 60,
            height = 20,
            random = 10,
          },
        },
      },
    },
    config = function(_, opts)
      local trouble_exists, trouble_snacks = pcall(require, 'trouble.sources.snacks')
      if trouble_exists then
        vim.tbl_deep_extend('force', opts or {}, {
          picker = {
            actions = require('trouble.sources.snacks').actions,
            win = {
              input = {
                keys = {
                  ['<c-t>'] = {
                    'trouble_open',
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        })
      end
      require('snacks').setup(opts)
    end,
  },
  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      max_count = 6,
      disable_mouse = false,
    },
  },
  {
    'godlygeek/tabular',
    event = 'VeryLazy',
  },
}
