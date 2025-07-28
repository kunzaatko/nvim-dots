-- TODO: Add more mappings. Some are in AstroNvim <11-05-23>
-- TODO: Add mappings to <C-|> and <C-\> in insert mode and '|', '\' in normal mode <11-05-23>
-- TODO: Add mappings to change the current picker <11-05-23>
-- TODO: Change the layout for different pickers <11-05-23>
-- TODO: Add numbers when in file picker and in normal mode <12-05-23>
local M = {
  'nvim-telescope/telescope.nvim',
  enbaled = false,
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
        prompt_prefix = static.icons.telescope .. ' ⟩ ',
        selection_caret = ' ',
        multi_icon = '● ',
        path_display = { 'truncate' },
        preview = {
          treesitter = {
            disable = { 'text', 'pdf' },
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
      '//',
      function()
        -- NOTE: Customised to add the fuzzy search into the search history <29-03-25>
        require('telescope.builtin').current_buffer_fuzzy_find({
          attach_mappings = function(_, _)
            require('telescope.actions').select_default:replace(function(bufnr)
              local searched_for = require('telescope.actions.state').get_current_line()
              vim.call('histadd', 'search', searched_for)
              require('telescope.actions.set').select(bufnr, 'default')
            end)
            return true
          end,
        }, { results_ts_highlight = true })
      end,
      desc = 'fuzzy-find in buffer',
    },
    {
      'gđ',
      function()
        require('telescope.builtin').find_files { hidden = true }
      end,
      desc = 'workspace files',
    },
    {
      'đ', -- Alt+s
      function()
        require('telescope.builtin').live_grep({
          attach_mappings = function(_, _)
            require('telescope.actions').select_default:replace(function(bufnr)
              local searched_for = require('telescope.actions.state').get_current_line()
              vim.call('histadd', 'search', searched_for)
              require('telescope.actions.set').select(bufnr, 'default')
            end)
            return true
          end,
        }, {})
      end,
      desc = 'grep workspace files',
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)

    ---@param mod table|string Modules to load conditionally
    local load_if_exists = function(mod)
      if type(mod) == 'string' then
        mod = { mod }
      end
      vim.iter(mod):map(function(mod)
        local exists, _ = pcall(require, mod)
        if exists then
          telescope.load_extension(mod)
        end
      end)
    end
    load_if_exists { 'luasnip', 'notify', 'persisted', 'aerial' }
    telescope.load_extension 'fzf'
  end,
}
return {}
