local utils = require 'pkg.utils'
local M = {
  -- TODO: Setup highlights <16-01-22, kunzaatko> --
  -- 'ggandor/leap.nvim' -- enhanced f,F,t,T with s,S for double letter searching and inter window
  -- searches with used labels {{{
  {
    'ggandor/leap.nvim',
    as = 'leap',
    keys = utils.get_multi_keys { { { 'n', 'v' }, { 's', 'S', 'gs' } }, { 'o', { 'z', 'Z', 'x', 'X' } } },
    config = function()
      -- NOTE: The `true` argument overwrites the keymaps that are registered with this function...
      -- this is because of which_key which sets these keymaps to nonacionable functionalities
      require('leap').set_default_keymaps(true)
    end,
  },
  -- }}}

  -- 'karb94/neoscroll.nvim' -- for smooth scrolling {{{
  {
    'karb94/neoscroll.nvim',
    keys = utils.get_multi_keys {
      { { 'n', 'x' }, { '<C-e>', '<C-y>', '<C-f>', '<C-d>', '<C-b>', '<C-u>' } },
      { { 'n', 'x' }, { { 'z' }, { 'z', 't', 'b' } } },
    },
    config = function()
      require('neoscroll').setup {
        easing_function = 'quadratic',
      }
    end,
  },
  -- }}}

  -- TODO: Add a keymap for switching between FilePicker and LiveGrep, since I often do not know
  -- beforhand which one to choose and want to choose at the spot. For that right now, I have to
  -- exit one picker and launch another and that should not be necessary. --
  -- TODO: Add buffer delete keymap into the buffer telescope pisker --
  -- TODO: Add transparency to default UI <16-01-22, kunzaatko> --
  -- TODO: Add colours --
  -- 'nvim-telescope/telescope.nvim' -- file finder and list shower {{{
  {
    'nvim-telescope/telescope.nvim',
    keys = utils.get_multi_keys {
      { 'n', { { '<leader>f' }, { 's', 'w', 'F', 'g', 'b', 'h', 'f', 'k', 'l' } } },
      { 'n', '<leader><leader>' },
    },
    cmd = 'Telescope',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', as = 'telescope_fzf_native', run = 'make' }, -- makes the search run faster
      { 'nvim-treesitter/nvim-treesitter' }, -- highlighting in the preview buffer
      { 'benfowler/telescope-luasnip.nvim' }, -- snippet listing
    },
    setup = function()
      local wk = require 'which-key'
      wk.register({
        f = {
          name = 'Telescope',
          s = { 'Spelling' },
          F = {
            'Find files',
          },
          g = { 'Live grep' },
          w = { 'Workspace files' },
          b = { 'Buffers' },
          h = { 'Help tags' },
          f = { 'Pickers' },
          k = { 'Keymaps' },
          l = { 'Luasnip' },
          ['<leader>'] = { 'Fuzzy buffer' },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      vim.cmd [[packadd trouble.nvim]]
      local trouble = require 'trouble.providers.telescope'
      require('telescope').setup {
        defaults = {
          prompt_prefix = ' ⟩ ',
          mappings = {
            i = { ['<C-q>'] = trouble.open_with_trouble },
            n = { ['<C-q>'] = trouble.open_with_trouble },
          },
        },
      }
      require('telescope').load_extension 'fzf'

      -- TODO: Do this with the plugin manager in neovim <21-03-22>
      if packer_plugins.notify.loaded == true then
        -- TODO: Defer the loading of this extension when notify is loaded <03-12-21, kunzaatko> --
        -- FIX: This does not work if the notification plugin is not loaded before
        -- telescope. It should therefore be loaded also in the notify config or one of
        -- the plugins should be deferebly loaded <09-03-22, kunzaatko> --
        require('telescope').load_extension 'notify'
      end

      require('telescope').load_extension 'luasnip'
      map('n', '<leader>fl', function()
        return require('telescope').extensions.luasnip.luasnip {}
      end, { silent = true, desc = 'LuaSnip snippets' })

      map('n', '<leader>fs', require('telescope.builtin').spell_suggest, { silent = true, desc = 'suggest spelling' })

      local git_files_or_find_files = function(opts)
        -- FIX: This does not give me files, should be sorted instead <27-10-22, kunzaatko>
        -- opts = opts or {}
        -- local ok, _ = pcall(require('telescope.builtin').git_files, opts)
        -- if not ok then
        require('telescope.builtin').find_files(opts)
        -- end
      end

      map('n', '<leader>fw', git_files_or_find_files, { silent = true, desc = 'workspace files' })
      map('n', '<leader>fF', function()
        return require('telescope.builtin').find_files()
      end, { silent = true, desc = 'find files' })
      map('n', '<leader>fg', function()
        return require('telescope.builtin').live_grep()
      end, { silent = true, desc = 'grep workspace lines' })
      map('n', '<leader>fb', function()
        return require('telescope.builtin').buffers()
      end, { silent = true, desc = 'select buffer' })
      map('n', '<leader>fh', function()
        return require('telescope.builtin').help_tags()
      end, { silent = true, desc = 'help tags' })
      map('n', '<leader>ff', function()
        return require('telescope.builtin').builtin()
      end, { silent = true, desc = 'select picker' })
      map('n', '<leader>fk', function()
        return require('telescope.builtin').keymaps()
      end, { silent = true, desc = 'list keymaps' })
      map('n', '<leader><leader>', function()
        return require('telescope.builtin').current_buffer_fuzzy_find()
      end, { silent = true, desc = 'fuzzy-find in buffer' })
    end,
  },
  -- }}}

  -- TODO: Configure icons and setup the <Tab> mapping so that it is not overwritten by the nvim
  -- tree <20-08-22, kunzaatko>
  -- 'kyazdani42/nvim-tree.lua' -- file explorer for neovim {{{
  {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      vim.keymap.set('n', '<Tab>', require('nvim-tree.api').tree.open, { desc = 'Open file explorer' })
      require('nvim-tree').setup {
        disable_netrw = true,
        open_on_tab = true,
        renderer = {
          icons = {
            git_placement = 'after',
            glyphs = {
              git = {
                unstaged = ' ',
                staged = ' ',
                unmerged = ' ',
                renamed = ' ',
                untracked = ' ',
                deleted = ' ',
                ignored = ' ',
              },
            },
          },
        },
        actions = {
          open_file = {
            window_picker = {
              chars = 'JKLIOHABCDEFGMNPQRSTUVWXYZ1234567890',
            },
          },
        },
      }
    end,
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
  },
  -- }}}

  -- 'edluffy/specs.nvim' -- highlight the cursor location after jump {{{
  {
    'edluffy/specs.nvim',
    as = 'specs',
    config = function()
      require('specs').setup {
        popup = {
          winhl = 'Search',
          fader = require('specs').exp_fader,
        },
      }
    end,
  }, -- }}}
}

return M
