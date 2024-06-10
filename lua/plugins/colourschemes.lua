return {
  {
    dir = '~/.config/nvim/dev/nord.nvim',
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
    name = 'nord',
    event = 'VeryLazy',
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
    event = 'VeryLazy',
    priority = 1000,
    dependencies = { { 'rktjmp/lush.nvim', name = 'lush' } },
  },
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_italic_functions = 1
    end,
  },
  { 'EdenEast/nightfox.nvim', name = 'nightfox', event = 'VeryLazy', priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
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
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', event = 'VeryLazy', priority = 1000 },
}
