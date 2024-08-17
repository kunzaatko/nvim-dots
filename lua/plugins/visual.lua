return {
  {
    'folke/todo-comments.nvim',
    name = 'todo-comments',
    dependencies = { 'plenary' },
    event = 'BufReadPost',
    opts = {
      highlight = { keyword = 'fg', after = '' },
      keywords = {
        FIX = {
          icon = static.icons.comments.bug .. ' ',
          color = 'error',
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'CHECK' },
        },
        TODO = { icon = static.icons.comments.todo .. ' ', color = 'info' },
        HACK = { icon = static.icons.comments.hack .. ' ', color = 'warning' },
        WARN = {
          icon = static.icons.diagnostics.Warn .. ' ',
          color = 'warning',
          alt = { 'WARNING', 'XXX', 'QUESTION', 'POLICY' },
        },
        PERF = { icon = static.icons.comments.performance .. ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = {
          icon = static.icons.comments.note .. ' ',
          color = 'hint',
          alt = { 'INFO', 'IDEA', 'IDEA!', 'RESEARCH' },
        },
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    name = 'notify',
    event = 'UIEnter',
    config = function()
      vim.notify = require 'notify'
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = true,
  },

  -- TODO: Configure <17-04-23>
  {
    'kevinhwang91/nvim-ufo',
    name = 'ufo',
    enabled = false,
    dependencies = {
      'kevinhwang91/promise-async',
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require 'statuscol.builtin'
          require('statuscol').setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          }
        end,
      },
    },
    event = 'BufReadPost',
    opts = {
      preview = {
        mappings = {
          scrollB = '<C-b>',
          scrollF = '<C-f>',
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == 'string' and err:match 'UfoFallbackException' then
            return require('ufo').getFolds(bufnr, providerName)
          else
            return require('promise').reject(err)
          end
        end

        return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
          or function(bufnr)
            return require('ufo')
              .getFolds(bufnr, 'lsp')
              :catch(function(err)
                return handleFallbackException(bufnr, err, 'treesitter')
              end)
              :catch(function(err)
                return handleFallbackException(bufnr, err, 'indent')
              end)
          end
      end,
    },
    config = function(_, opts)
      -- TODO: Test... Does it work. Design a system that registers capabilities before the configuration of
      -- servers <10-06-23>
      require('util').lsp.capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      require('ufo').setup(opts)
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
    },
  },
  {
    'edluffy/specs.nvim',
    name = 'specs',
    enabled = false, -- TODO: When fixed for nightly can be enabled again <26-03-24>
    event = 'UIEnter',
    config = true,
  },
  {
    'j-hui/fidget.nvim',
    name = 'fidget',
    event = 'LspAttach',
    config = true,
  },
  -- TODO: Disable on non-focused windows or at least change the settings so that it does not show diagnostics <02-05-23>
  {
    'petertriho/nvim-scrollbar',
    -- enabled = false,
    event = 'BufReadPost',
    opts = {
      excluded_filetypes = { 'prompt', 'TelescopePrompt', 'noice', 'notify' },
    },
  },

  -- TODO: Configure colours <05-10-23>
  {
    'lukas-reineke/indent-blankline.nvim',
    name = 'indent-blankline',
    event = 'BufReadPost',
    main = 'ibl',
    -- enabled = false,
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        char = '┃',
        -- show_first_indent_level = false,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'tex', -- FIX: LaTeX makes indent-blankline very slow, which considerably lowers the speed of insertmode input <18-01-24>
          'help',
          'markdown',
          'packer',
          'lspinfo',
          'checkhealth',
          'txt',
          'alpha',
          'lazy',
          'mason',
          'DiffviewFiles',
          'oil_preview',
          'dashboard',
        },
        buftypes = {
          'terminal',
        },
      },
      -- space_char = '·',
    },
  },
  { 'Bekaboo/deadcolumn.nvim', event = 'VeryLazy', enabled = false },
  {
    'tzachar/highlight-undo.nvim',
    event = 'VeryLazy',
    config = function()
      require('highlight-undo').setup {
        hlgroup = 'Search',
        duration = 300,
        keymaps = {
          { 'n', 'u', 'undo', {} },
          { 'n', '<C-r>', 'redo', {} },
        },
      }
    end,
  },
  {
    'mawkler/modicator.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local set = vim.api.nvim_set_hl
      local get = vim.api.nvim_get_hl
      -- NOTE: Chosen to match the colours in heirline config <kunzaatko>
      set(0, 'NormalMode', { fg = '#BE6069', bg = 'bg' })
      set(0, 'InsertMode', { fg = '#EBCA89', bg = 'bg' })
      set(0, 'VisualMode', { fg = '#81A1C1', bg = 'bg' })
      set(0, 'CommandMode', { fg = '#B48EAD', bg = 'bg' })
      set(0, 'ReplaceMode', { fg = '#A77B9F', bg = 'bg' })
      set(0, 'SelectMode', { fg = '#D18771', bg = 'bg' })
      set(0, 'TerminalMode', { fg = 'fg', bg = 'bg' })
      set(0, 'TerminalNormalMode', { fg = 'fg', bg = 'bg' })
      require('modicator').setup(opts)
    end,
  },
  {
    'Isrothy/neominimap.nvim',
    enabled = true,
    lazy = false, -- NOTE: It lazy-loads itself <17-08-24>
    keys = {
      { '<leader>m', '<cmd>Neominimap bufToggle<cr>', desc = 'Toggle minimap for current buffer' },
    },
    init = function()
      -- vim.opt.wrap = false -- Recommended
      -- vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
      vim.g.neominimap = {
        auto_enable = true,
        win_filter = function(bufnr)
          return vim.g.neominimap_is_in_search
        end,
        exclude_buftypes = {
          'nofile',
          'nowrite',
          'quickfix',
          'terminal',
          'prompt',
        },
        buf_filter = function()
          return true
        end,
        -- TODO: Highlight for cursor position should be different than the search to distinguish them <17-08-24>
        search = {
          enabled = true,
          mode = 'line',
        },
      }
      vim.on_key(function(char)
        if vim.fn.mode() == 'n' then
          local is_search_nav_key = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
          if is_search_nav_key then
            vim.g.neominimap_is_in_search = true
            require('neominimap').winRefresh({}, {})
          else
            vim.g.neominimap_is_in_search = false
            require('neominimap').winRefresh({}, {})
          end
        end
      end, vim.api.nvim_create_namespace 'auto_search_nav')
    end,
  },
}
