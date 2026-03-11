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
    keys = {
      {
        '_',
        function()
          require('oil').open()
        end,
        desc = 'Open parent directory',
      },
      {
        'g_',
        function()
          require('oil').open(vim.fn.getcwd())
        end,
        desc = 'Open current working directory',
      },
    },
    dependencies = { { 'nvim-tree/nvim-web-devicons', name = 'devicons' }, 'benomahony/oil-git.nvim' },
    config = function(_, opts)
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
    event = 'VeryLazy',
    keys = {
      {
        '<M-h>',
        '<Cmd>SmartCursorMoveLeft<CR>',
        desc = 'move to left split',
      },
      {
        '<M-j>',
        '<Cmd>SmartCursorMoveDown<CR>',
        desc = 'move to below split',
      },
      {
        '<M-k>',
        '<Cmd>SmartCursorMoveUp<CR>',
        desc = 'move to above split',
      },
      {
        '<M-l>',
        '<Cmd>SmartCursorMoveRight<CR>',
        desc = 'move to right split',
      },
      {
        '<M-Up>',
        function()
          require('smart-splits').resize_up()
        end,
        desc = 'resize split up',
      },
      {
        '<M-Down>',
        function()
          require('smart-splits').resize_down()
        end,
        desc = 'resize split down',
      },
      {
        '<M-Left>',
        function()
          require('smart-splits').resize_left()
        end,
        desc = 'resize split left',
      },
      {
        '<M-Right>',
        function()
          require('smart-splits').resize_right()
        end,
        desc = 'resize split right',
      },
      {
        '<leader><M-h>',
        function()
          require('smart-splits').swap_buf_left()
        end,
        desc = 'swap split left',
      },
      {
        '<leader><M-j>',
        function()
          require('smart-splits').swap_buf_down()
        end,
        desc = 'swap split down',
      },
      {
        '<leader><M-k>',
        function()
          require('smart-splits').swap_buf_up()
        end,
        desc = 'swap split up',
      },
      {
        '<leader><M-l>',
        function()
          require('smart-splits').swap_buf_right()
        end,
        desc = 'swap split right',
      },
    },
    opts = { ignored_filetypes = { 'nofile', 'quickfix', 'qf', 'prompt' }, ignored_buftypes = { 'nofile' } },
  },
  {
    'folke/which-key.nvim',
    opts = {
      preset = 'helix',
      icons = { group = '', separator = '' }, -- TODO: Change the separator to something better <08-05-25>
      disable = { ft = { 'TelescopePrompt' } },
      spelling = {
        enabled = true,
        suggestions = 6, -- FIX: Number of suggestions is not respected by the plugin <08-05-25>
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
    end,
  },
  {
    'numToStr/Comment.nvim',
    name = 'Comment',
    keys = { { 'gb', mode = 'v' }, { 'gc', mode = 'v' }, 'gcc', 'gc', 'gco', 'gcO', 'gcA', 'gb', 'gbc' },
    config = true,
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
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = 'BufReadPost',
    opts = {
      select = {
        enable = true,
        lookahead = false,
        keymaps = {},
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      local select = require('nvim-treesitter-textobjects.select').select_textobject
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select('@function.outer', 'textobjects')
      end, { desc = 'select Around Function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select('@function.inner', 'textobjects')
      end, { desc = 'select In Function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select('@class.outer', 'textobjects')
      end, { desc = 'select Around Class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select('@class.inner', 'textobjects')
      end, { desc = 'select In Class' })
      vim.keymap.set({ 'x', 'o' }, 'ap', function()
        select('@parameter.outer', 'textobjects')
      end, { desc = 'select Around Parameter' })
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        select('@statement.outer', 'textobjects')
      end, { desc = 'select Around Statement' })
      vim.keymap.set({ 'x', 'o' }, 'ad', function()
        select('@string.documentation', 'highlights')
      end, { desc = 'select Around Docstring' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      -- custom parsers
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'TSUpdate', 'TSInstall' },
        callback = function()
          require('nvim-treesitter.parsers').ghactions = {
            install_info = {
              url = 'https://github.com/rmuir/tree-sitter-ghactions',
              queries = 'queries',
            },
          }
        end,
      })

    -- stylua: ignore start
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterHighlighting', {}),
        pattern = {
          'bash', 'bibtex', 'c', 'cpp', 'css', 'diff', 'fish', 'gitcommit', 'gitignore', 'go', 'html', 'htmldjango',
          'json', 'julia', 'just', 'lua', 'markdown', 'markdown_inline', 'norg', 'python', 'query', 'r', 'ron', 'rust',
          'scss', 'sql', 'toml', 'typst', 'vim', 'yaml'
        },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
    -- stylua: ignore end
  },
  {
    'olimorris/persisted.nvim',
    lazy = false,
    config = true,
  },
  -- TODO: Use the `icon` utils for setting icons <30-03-25>
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      -- Zen --
      {
        '<leader><leader>',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Toggle Zen zoom',
      },
      {
        'g<leader>',
        function()
          Snacks.zen.zen()
        end,
        desc = 'Toggle Zen mode',
      },
      -- Terminal --
      {
        'ŧ',
        function()
          require('util.terminal').toggle_repl('fish', 'ŧ')
        end,
        desc = 'Toggle terminal',
      },
      -- TODO: Use this `vim.fs.root({source}, {marker})` for terminal in the current project <24-06-25>
      {
        'gŧ',
        function()
          require('util.terminal').toggle_repl('fish', 'ŧ', { cwd = vim.fn.expand '%:p:h' })
        end,
        desc = 'Toggle terminal in the current file directory',
      },
      -- Pickers & Explorer --
      {
        '<leader><space>',
        function()
          Snacks.picker.smart()
        end,
        desc = 'Smart Find Files',
      },
      {
        '<leader>.',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '//',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        'đ', -- Alt+s
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>đ', -- <leader>+<Alt+s>
        function()
          Snacks.picker.pickers()
        end,
        desc = 'Pickers',
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
      zen = {
        toggles = {
          dim = false,
        },
        win = {
          width = 180,
        },
      },
      bigfile = {},
      quickfile = {},
      notifier = {},
      statuscolumn = {},
      indent = {},
      input = {},
      terminal = {
        shell = 'fish',
        win = {
          winbar = '',
          position = 'bottom',
          keys = {
            toggle_normal = {
              '<C-n>',
              function()
                vim.cmd 'stopinsert'
              end,
              mode = { 't' },
              desc = 'Normal mode',
            },
          },
        },
      },
      -- scroll = {},
      words = {},
      ---@class snacks.picker.Config
      picker = {
        sources = {
          lines = {
            win = {
              preview = {
                wo = {
                  cursorlineopt = 'line',
                },
              },
            },
          },
        },
        win = {
          input = {
            keys = {
              ['<a-s>'] = { 'flash', mode = { 'n', 'i' } }, -- FIX: Does not work on MacOS <10-03-2026>
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
          -- FIX: Only include this if `fortune` and `cowsay` are available commands <11-03-2026>
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
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '!s'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '!w'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '!L'
          Snacks.toggle.diagnostics():map '!d'
          Snacks.toggle.line_number():map '!l'
          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map '!c'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '!b'
          Snacks.toggle.inlay_hints():map '!h'
          Snacks.toggle.indent():map '!g'
          Snacks.toggle.dim():map '!D'
        end,
      })
    end,
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
    'chrisgrieser/nvim-spider',
    keys = {
      { 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
      { 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
      { 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
    },
  },
  {
    'godlygeek/tabular',
    event = 'VeryLazy',
  },
  {
    'andymass/vim-matchup',
    lazy = false,
    init = function()
      vim.g.matchup_treesitter_stopline = 500
      vim.g.matchup_text_obj_enabled = 0
      vim.g.matchup_matchparen_offscreen = {}
    end,
    ---@type matchup.Config
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
  },
  -- Quickfix --
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}
