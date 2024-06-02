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
        NOTE = { icon = static.icons.comments.note .. ' ', color = 'hint', alt = { 'INFO', 'IDEA', 'IDEA!' } },
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

  -- COLOUR SCHEMES --
  {
    dir = '~/.config/nvim/dev/nord.nvim',
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
    name = 'nord',
    priority = 1000,
    config = function()
      vim.g.nord_italic = 1
      vim.g.nord_italic_comments = 1
      vim.g.nord_cursor_line_number_background = 1
      vim.g.nord_underline = 1
      vim.g.nord_langs = {
        'c',
        'cmake',
        'gitconfig',
        'gitcommit',
        'go',
        'help',
        'sh',
        'vim',
        'yaml',
        'html',
        'lua',
        'markdown',
        'json',
        'python',
        'rust',
      }
      vim.g.nord_pkgs = {
        'luasnips',
        'cmp_vscode',
        'gitsigns',
        'nvim-telescope',
        'vim-startify',
        'vimtex',
      }
    end,
  },
  {
    'npxbr/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000,
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
  },
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    priority = 1000,
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_italic_functions = 1
    end,
  },
  { 'EdenEast/nightfox.nvim', name = 'nightfox', priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {

      dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.05,
      },
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        strings = { 'italic' },
        booleans = { 'italic' },
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = {},
            hints = { 'italic' },
            warnings = {},
            information = { 'italic' },
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'underline' },
            warnings = { 'undercurl' },
            information = { 'underline' },
          },
        },
        lsp_trouble = true,
        cmp = true,
        gitsigns = true,
        telescope = true,
        dap = {
          enabled = false,
          enable_ui = false,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        neogit = true,
        bufferline = true,
        lightspeed = true,
        ts_rainbow = true,
        notify = true,
        symbols_outline = true,
        mini = false,
        vimwiki = false,
        beacon = false,
      },
    },
    config = function()
      vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha
    end,
  },
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', priority = 1000 },
}
