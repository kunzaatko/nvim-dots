-- TODO: Add more mappings. Some are in AstroNvim <11-05-23>
-- TODO: Add mappings to <C-|> and <C-\> in insert mode and '|', '\' in normal mode <11-05-23>
-- TODO: Add mappings to change the current picker <11-05-23>
-- TODO: Change the layout for different pickers <11-05-23>
-- TODO: Add numbers when in file picker and in normal mode <12-05-23>
return {
  'nvim-telescope/telescope.nvim',
  name = 'telescope',
  dependencies = {
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      name = 'telescope-fzf',
      enabled = vim.fn.executable 'cmake' ~= 0,
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    },
    { 'benfowler/telescope-luasnip.nvim', name = 'telescope-luasnip' },
    { 'nvim-lua/plenary.nvim', name = 'plenary' },
  },
  opts = function()
    local actions = require 'telescope.actions'
    return {
      defaults = {
        prompt_prefix = ' ⟩ ',
        selection_caret = ' ',
        multi_icon = '● ',
        path_display = { 'truncate' },
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        preview = {
          treesitter = {
            enable = true,
          },
        },
        mappings = {
          i = {
            ['<C-n>'] = actions.cycle_history_next,
            ['<C-p>'] = actions.cycle_history_prev,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<c-t>'] = require('trouble.sources.telescope').open,
            ['<c-down>'] = actions.cycle_history_next,
            ['<c-up>'] = actions.cycle_history_prev,
          },
          n = {
            ['<c-t>'] = require('trouble.sources.telescope').open,
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        },
      },
    }
  end,
  cmd = 'Telescope',
  keys = {
    {
      '<leader>f',
      require('telescope.builtin').builtin,
      desc = 'find',
    },
    {
      '//',
      require('telescope.builtin').current_buffer_fuzzy_find,
      desc = 'fuzzy-find in buffer',
    },
    {
      'Đ',
      function()
        require('telescope.builtin').find_files { hidden = true }
      end,
      desc = 'workspace files',
    },
    {
      'đ', -- Alt+s
      require('telescope.builtin').live_grep,
      desc = 'grep workspace files',
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)
    telescope.load_extension 'luasnip'

    local notify_exists, _ = pcall(require, 'notify')
    if notify_exists then
      telescope.load_extension 'notify'
    end

    local aerial_exists, _ = pcall(require, 'aerial')
    if aerial_exists then
      telescope.load_extension 'aerial'
    end

    telescope.load_extension 'fzf'
  end,
}
