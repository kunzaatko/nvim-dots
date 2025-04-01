return {
  {
    dir = '~/.config/nvim/dev/nord.nvim',
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
    name = 'clr-nord',
    event = 'VeryLazy',
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
        'blink_cmp',
        'gitsigns',
        'nvim-telescope',
        'vim-startify',
        'vimtex',
      }
    end,
  },
  {
    'npxbr/gruvbox.nvim',
    name = 'clr-gruvbox',
    event = 'VeryLazy',
    priority = 1000,
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
  },
  {
    'folke/tokyonight.nvim',
    name = 'clr-tokyonight',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_italic_functions = 1
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    name = 'clr-nordic',
    event = 'VeryLazy',
    priority = 1000,
    opts = {
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        indent_blankline = true,
        which_key = true,
        trouble = true,
        vimtex = true,
        treesitter = true,
        telescope = true,
      },
    },
    config = function(_, opts)
      require('nordic').setup(opts)
    end,
  },
  -- TODO: In LaTeX the conceal should not be so dim. In fact maybe it would be best if conceal didn't have any
  -- highlight. <26-01-25>
  {
    'EdenEast/nightfox.nvim',
    name = 'clr-nightfox',
    event = 'VeryLazy',
    priority = 1000,
    opts = {},
    config = function(_, opts)
      opts.groups = opts.groups or {}

      local blink_groups = {
        all = {
          BlinkCmpMenuSelection = { bg = 'bg2', style = 'bold' }, -- The completion menu window selected item
          BlinkCmpScrollBarThumb = { fg = 'palette.red.dim', style = 'bold' }, -- The scrollbar thumb
          BlinkCmpScrollBarGutter = { fg = 'bg2' }, -- The scrollbar gutter
          BlinkCmpLabel = { fg = 'fg2' }, -- Label of the completion item
          BlinkCmpLabelDeprecated = { style = 'strikethrough', fg = 'bg4' }, -- Deprecated label of the completion item
          BlinkCmpLabelMatch = { fg = 'fg0', style = 'bold' }, -- Label of the completion item when it matches the query
          BlinkCmpLabelDetail = { fg = 'palette.blue.bright' }, -- FIX: I am not sure what this is -- Label description of the completion item
          BlinkCmpKind = { fg = 'palette.green.bright', bg = 'palette.green.dim' }, -- Kind icon/text of the completion item

          BlinkCmpKindText = { fg = 'palette.green.dim' },
          BlinkCmpKindEnum = { link = 'BlinkCmpKindText' },
          BlinkCmpKindKeyword = { link = 'BlinkCmpKindText' },

          BlinkCmpKindIconText = { fg = 'palette.green' },
          BlinkCmpKindIconEnum = { link = 'BlinkCmpKindIconText' },
          BlinkCmpKindIconKeyword = { link = 'BlinkCmpKindIconText' },

          BlinkCmpKindConstant = { fg = 'palette.yellow.dim' },
          BlinkCmpKindConstructor = { link = 'BlinkCmpKindConstant' },
          BlinkCmpKindReference = { link = 'BlinkCmpKindConstant' },

          BlinkCmpKindIconConstant = { fg = 'palette.yellow.dim' },
          BlinkCmpKindIconConstructor = { link = 'BlinkCmpKindIconConstant' },
          BlinkCmpKindIconReference = { link = 'BlinkCmpKindIconConstant' },

          BlinkCmpKindField = { fg = 'palette.green.dim' },

          BlinkCmpKindIconField = { fg = 'palette.green' },

          BlinkCmpKindProperty = { fg = 'palette.cyan.dim' },

          BlinkCmpKindIconProperty = { fg = 'palette.cyan' },

          BlinkCmpKindFunction = { fg = 'palette.magenta.dim' },
          BlinkCmpKindModule = { link = 'BlinkCmpKindFunction' },
          BlinkCmpKindOperator = { link = 'BlinkCmpKindFunction' },
          BlinkCmpKindStruct = { link = 'BlinkCmpKindFunction' },
          BlinkCmpKindClass = { link = 'BlinkCmpKindFunction' },

          BlinkCmpKindIconFunction = { fg = 'palette.magenta' },
          BlinkCmpKindIconModule = { link = 'BlinkCmpKindIconFunction' },
          BlinkCmpKindIconOperator = { link = 'BlinkCmpKindIconFunction' },
          BlinkCmpKindIconStruct = { link = 'BlinkCmpKindIconFunction' },
          BlinkCmpKindIconClass = { link = 'BlinkCmpKindIconFunction' },

          BlinkCmpKindVariable = { fg = 'fg2' },
          BlinkCmpKindFile = { link = 'BlinkCmpKindVariable' },

          BlinkCmpKindIconVariable = { fg = 'fg3' },
          BlinkCmpKindIconFile = { link = 'BlinkCmpKindIconFile' },

          BlinkCmpKindUnit = { fg = 'palette.yellow.dim' },
          BlinkCmpKindSnippet = { link = 'BlinkCmpKindUnit' },
          BlinkCmpKindFolder = { link = 'BlinkCmpKindUnit' },

          BlinkCmpKindIconUnit = { fg = 'palette.yellow.dim' },
          BlinkCmpKindIconSnippet = { link = 'BlinkCmpKindIconUnit' },
          BlinkCmpKindIconFolder = { link = 'BlinkCmpKindIconUnit' },

          BlinkCmpKindMethod = { fg = 'palette.blue' },
          BlinkCmpKindValue = { link = 'BlinkCmpKindMethod' },
          BlinkCmpKindEnumMember = { link = 'BlinkCmpKindMethod' },

          BlinkCmpKindIconMethod = { fg = 'palette.blue.bright' },
          BlinkCmpKindIconValue = { link = 'BlinkCmpKindIconMethod' },
          BlinkCmpKindIconEnumMember = { link = 'BlinkCmpKindIconMethod' },

          BlinkCmpKindInterface = { fg = 'palette.green' },
          BlinkCmpKindColor = { link = 'BlinkCmpKindInterface' },
          BlinkCmpKindTypeParameter = { link = 'BlinkCmpKindInterface' },

          BlinkCmpKindIconInterface = { fg = 'palette.green.bright' },
          BlinkCmpKindIconColor = { link = 'BlinkCmpKindIconInterface' },
          BlinkCmpKindIconTypeParameter = { link = 'BlinkCmpKindIconInterface' },

          BlinkCmpSource = { fg = 'palette.magenta.dim' }, -- Source of the completion item
        },
      }
      opts.groups = vim.tbl_deep_extend('error', opts.groups, blink_groups)

      require('nightfox').setup(opts)
    end,
  },
  {
    'catppuccin/nvim',
    name = 'clr-catppuccin',
    event = 'VeryLazy',
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
        cmp = false,
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
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', event = 'VeryLazy', priority = 1000 },
}
