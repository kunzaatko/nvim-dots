local utils = require 'pkg.utils'
local M = {
  -- TODO: Setup highlights <16-01-22, kunzaatko> --
  -- 'ggandor/lightspeed.nvim' -- enhanced f,F,t,T and s,S for double letter searching {{{
  {
    'ggandor/lightspeed.nvim',
    as = 'lightspeed',
    keys = utils.get_keys('n', { 's', 'S', 'f', 'F', 't', 'T' }),
    requires = { 'tpope/vim-repeat', as = 'repeat' },
  },
  -- }}}

  -- 'karb94/neoscroll.nvim' -- for smooth scrolling {{{
  {
    'karb94/neoscroll.nvim',
    as = 'neoscroll',
    config = function()
      require('neoscroll').setup()
    end,
  },
  -- }}}

  -- TODO: Add transparency to default UI <16-01-22, kunzaatko> --
  -- 'nvim-telescope/telescope.nvim' -- file finder and list shower {{{
  {
    'nvim-telescope/telescope.nvim',
    keys = utils.get_multi_keys {
      { 'n', { { '<leader>f' }, { 's', 'w', 'F', 'g', 'b', 'h', 'f', 'k' } } },
      { 'n', '<leader><leader>' },
    },
    cmd = 'Telescope',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', as = 'telescope_fzf_native', run = 'make' }, -- makes the search run faster
      { 'nvim-treesitter/nvim-treesitter' }, -- highlighting in the preview buffer
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
          ['<leader>'] = { 'Fuzzy buffer' },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
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

      if packer_plugins.notify.loaded == true then
        -- TODO: Defer the loading of this extension when notify is loaded <03-12-21, kunzaatko> --
        -- FIX: This does not work if the notification plugin is not loaded before
        -- telescope. It should therefore be loaded also in the notify config or one of
        -- the plugins should be deferebly loaded <09-03-22, kunzaatko> --
        require('telescope').load_extension 'notify'
      end

      vim.api.nvim_set_keymap(
        'n',
        '<leader>fs',
        "<Cmd>lua require'telescope.builtin'.spell_suggest()<CR>",
        { noremap = true, silent = true }
      )

      _G.MUtils.git_files_or_find_files = function(opts)
        opts = opts or {}
        local ok = pcall(require('telescope.builtin').git_files, opts)
        if not ok then
          require('telescope.builtin').find_files(opts)
        end
      end
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fw',
        '<Cmd>lua _G.MUtils.git_files_or_find_files({})<CR>',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fF',
        "<Cmd>lua require'telescope.builtin'.find_files()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fg',
        "<Cmd>lua require'telescope.builtin'.live_grep()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fb',
        "<Cmd>lua require'telescope.builtin'.buffers()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fh',
        "<Cmd>lua require'telescope.builtin'.help_tags()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ff',
        "<Cmd>lua require'telescope.builtin'.builtin()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>fk',
        "<Cmd>lua require'telescope.builtin'.keymaps()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader><leader>',
        "<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
  -- }}}

  -- 'luukvbaal/stabilize.nvim' -- stabilizes the widnows on split creation {{{
  {
    'luukvbaal/stabilize.nvim',
    as = 'stabilize',
    config = function()
      require('stabilize').setup()
    end,
  },
  --}}}

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
