local utils = require 'pkg.utils'
local M = {
  -- TODO: Highlight in pop-up docs of LSP <16-01-22, kunzaatko> --
  -- 'norcalli/nvim-colorizer.lua' -- colours visualizer {{{
  {
    'norcalli/nvim-colorizer.lua',
    as = 'colorizer',
    ft = { 'css', 'javascript', 'vim', 'html', 'lua', 'tex', 'cfg', 'dosini', 'sh', 'toml' },
    config = function()
      require('colorizer').setup({
        'css',
        'javascript',
        'html',
        'dosini',
        'tex',
        'cfg',
        'sh',
        'toml',
        vim = { names = false, hsl_fn = true },
        lua = { names = false, hsl_fn = true },
      }, { mode = 'foreground' })
    end,
  },
  -- }}}

  {
    'SmiteshP/nvim-navic',
    requires = 'neovim/nvim-lspconfig',
  },

  -- FIX: Make the colours independent of the nord theme <kunzaatko> --
  -- 'rebelot/heirline.nvim' -- status line {{{
  {
    'rebelot/heirline.nvim',
    as = 'heirline',
    config = function()
      local statusline = require 'conf.pkgs.heirline'
      require('heirline').setup(statusline)
    end,
    after = 'lush.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons' },
      { 'rktjmp/lush.nvim' },
    },
  },
  -- }}}

  -- TODO: Do not show fidget in zenmode <14-03-22, kunzaatko> --
  -- 'folke/zen-mode.nvim' --  focus mode{{{
  {
    'folke/zen-mode.nvim',
    as = 'zen_mode',
    cmd = { 'ZenMode' },
    keys = utils.get_keys('n', '<leader>z'),
    setup = function()
      local wk = require 'which-key'
      wk.register({ z = { 'ZenMode' } }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      require('zen-mode').setup {
        window = {
          width = 0.85,
          options = {
            foldcolumn = '0',
          },
        },
        plugins = {
          gitsigns = { enabled = false },
          fidget = { enabled = false },
        },
      }
      map('n', '<leader>z', function()
        return require('zen-mode').toggle()
      end, { silent = true, desc = 'toggle Zen-mode' })
    end,
  },
  -- }}}

  -- 'lukas-reineke/indent-blankline.nvim' -- indentation guides {{{
  {
    'lukas-reineke/indent-blankline.nvim',
    as = 'indent_blankline',
    config = function()
      require('indent_blankline').setup {
        char = '│',
        show_current_context = true,
        context_char = '┃',
        use_treesitter = true,
        show_first_indent_level = false,
        filetype_exclude = { 'help', 'markdown', 'packer', 'lspinfo', 'checkhealth', 'txt', 'alpha' },
        buftype_exclude = { 'terminal' },
        space_char = '·',
      }
    end,
  },
  -- }}}

  -- 'folke/todo-comments.nvim' -- todo comments and todo quickfix-list {{{
  {
    'folke/todo-comments.nvim',
    as = 'todo_comments',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local map = vim.keymap.set
      require('todo-comments').setup {
        highlight = { keyword = 'fg', after = '' },
        keywords = {
          FIX = {
            icon = ' ',
            color = 'error',
            alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
          },
          TODO = { icon = ' ', color = 'info' },
          HACK = { icon = ' ', color = 'warning' },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
          PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        },
      }
      map('n', '<leader>T', '<Cmd>TodoTrouble<CR>', { silent = true, desc = 'toggle Todo-comments listing' })
    end,
  },
  -- }}}

  -- 'rcarriga/nvim-notify' -- notification UI for neovim {{{
  {
    'rcarriga/nvim-notify',
    as = 'notify',
    after = 'nord',
    config = function()
      -- NOTE: Use require'notify'.notify as the default notification UI. <kunzaatko> --
      vim.notify = require 'notify'
    end,
  },
  -- }}}

  -- TODO: Configure and set colours same as telescope <12-03-22, kunzaatko> --
  -- 'stevearc/dressing.nvim' -- UI component overrides for nvim {{{
  -- {
  --   'stevearc/dressing.nvim',
  --   module = 'vim.ui',
  --   config = function()
  --     require('dressing').setup {}
  --   end,
  -- },
  -- }}}

  -- TODO: Set colours and configure <12-03-22, kunzaatko> --
  -- 'j-hui/fidget.nvim' -- lspmessages in the right corner {{{

  {
    'j-hui/fidget.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('fidget').setup {
        text = {
          spinner = 'circle_halves',
        },
      }
      vim.api.nvim_create_autocmd('VimLeavePre', { command = [[silent! FidgetClose]] })
    end,
  },
  -- }}}

  -- TODO: Change style of font in active tab <28-11-21, kunzaatko> --
  -- TODO: Mappings to remove buffer also from bufferline <16-01-22, kunzaatko> --
  -- TODO: Make this work with auto-session <16-01-22, kunzaatko> --
  -- 'akinsho/bufferline.nvim' -- buffer symbols and nicer UI {{{
  {
    'akinsho/bufferline.nvim',
    as = 'bufferline',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local map = vim.keymap.set
      require('bufferline').setup {
        options = {
          numbers = function(opts)
            return string.format('%s·%s', opts.ordinal, opts.lower(opts.id))
          end,
          always_show_bufferline = false,
          show_close_icon = false,
          buffer_close_icon = '',
          close_icon = '',
          show_buffer_close_icon = false,
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype ~= 'startify' then
              return true
            end
          end,
        },
      }
      map('n', '<leader>b', '<Cmd>BufferLinePick<CR>', { silent = true, desc = 'pick a buffer' })
      local keys = { '+', 'ě', 'š', 'č', 'ř', 'ž', 'ý', 'á', 'í' }
      for i, k in ipairs(keys) do
        map(
          'n',
          '<leader>' .. k,
          '<Cmd>BufferLineGoToBuffer ' .. tostring(i) .. '<CR>',
          { silent = true, desc = 'go to buffer ' .. tostring(i) }
        )
      end
    end,
  },
  -- }}}

  -- TODO: Loading time? Should it be implemented in lua?  https://github.com/romainl/vim-cool <12-03-22, kunzaatko> --
  -- disable search highlight when done with searching
  { 'romainl/vim-cool', as = 'cool' },

  -- FIX: Not gorging with heirline.nvim <15-03-22, kunzaatko> --
  -- 'xiyaowong/nvim-transparent' -- toggle transparent nvim UI {{{
  {
    'xiyaowong/nvim-transparent',
    as = 'transparent',
    cmd = { 'TransparentEnable', 'TransparentDisable', 'TransparentToggle' },
    config = function()
      require('transparent').setup {
        enable = true,
        exclude = {},
      }
    end,
  },
  -- }}}
  --

  ----------------------
  --  colour-schemes  --
  ----------------------
  -- 'npxbr/gruvbox.nvim' -- colour-scheme {{{
  {
    'npxbr/gruvbox.nvim',
    as = 'gruvbox',
    requires = { 'rktjmp/lush.nvim' },
    after = { 'lush.nvim' },
    cond = 'false',
  },
  -- }}}

  -- 'kunzaatko/nord.nvim' -- colour-scheme {{{
  {
    '~/.config/nvim/pack/opt/nord.nvim',
    as = 'nord',
    requires = { 'rktjmp/lush.nvim', opt = true },
    setup = function()
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
        'cmp_vscode',
        'gitsigns',
        'nvim-telescope',
        'vim-startify',
        'vimtex',
      }
    end,
    config = function()
      vim.cmd 'colorscheme nord'
    end,
  },
  -- }}}

  -- 'kunzaatko/mia.nvim' -- colour-scheme {{{
  {
    '~/.config/nvim/pack/opt/mia.nvim/mia',
  },
  -- }}}

  -- 'folke/tokyonight.nvim' -- colour-scheme {{{
  {
    'folke/tokyonight.nvim',
    setup = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_italic_functions = 1
    end,
  },
  -- }}}

  { 'EdenEast/nightfox.nvim' },

  -- 'catppuccin/nvim' -- colour-scheme {{{
  {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha
      require('catppuccin').setup {
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
      }
    end,
  },
  -- }}}

  { 'rebelot/kanagawa.nvim' },
}
return M
