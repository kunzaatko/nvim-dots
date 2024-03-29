local utils = require 'pkg.utils'

local M = {
  -- 'sindrets/diffview.nvim' -- viewing diff of files in tree {{{
  {
    'sindrets/diffview.nvim',
    keys = utils.get_keys('n', '<leader>D'),
    module = 'diffview',
    config = function()
      -- FIX: This is deprecated. Get the new method of setting callbacks in the README <22-08-22, kunzaatko>
      local cb = require('diffview.config').diffview_callback
      local map = vim.keymap.set
      _G.MUtils = _G.MUtils or {}
      _G.MUtils.close_diffview = function()
        vim.cmd [[tabclose]]
      end
      require('diffview').setup {
        key_bindings = {
          disable_defaults = true,
          view = {
            ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<leader><leader>'] = cb 'toggle_files',
            ['gf'] = cb 'goto_file',
          },
          file_panel = {
            ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['j'] = cb 'next_entry',
            ['<down>'] = cb 'next_entry',
            ['k'] = cb 'prev_entry',
            ['<up>'] = cb 'prev_entry',
            ['<cr>'] = cb 'select_entry',
            ['o'] = cb 'select_entry',
            ['<2-LeftMouse>'] = cb 'select_entry',
            ['<tab>'] = cb 'select_next_entry',
            ['<s-tab>'] = cb 'select_prev_entry',
            ['i'] = cb 'listing_style',
            ['f'] = cb 'toggle_flatten_dirs',
            ['gf'] = cb 'goto_file',
            ['<leader><leader>'] = cb 'toggle_files',
          },
          file_history_panel = {
            ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['g!'] = cb 'options',
            ['y'] = cb 'copy_hash',
            ['zR'] = cb 'open_all_folds',
            ['zM'] = cb 'close_all_folds',
            ['j'] = cb 'next_entry',
            ['<down>'] = cb 'next_entry',
            ['k'] = cb 'prev_entry',
            ['<up>'] = cb 'prev_entry',
            ['<cr>'] = cb 'select_entry',
            ['o'] = cb 'select_entry',
            ['<2-LeftMouse>'] = cb 'select_entry',
            ['<tab>'] = cb 'select_next_entry',
            ['<s-tab>'] = cb 'select_prev_entry',
            ['<leader><leader>'] = cb 'toggle_files',
          },
          option_panel = { ['<tab>'] = cb 'select', ['q'] = cb 'close' },
        },
        hooks = {
          diff_buf_read = function()
            vim.opt_local.spell = false
            vim.opt_local.list = false
          end,
        },
      }
      map('n', '<leader>D', '<Cmd>DiffviewOpen<CR>', { silent = true, desc = 'open Diffview' })
    end,
  },
  -- }}}

  -- TODO: configure <03-03-22, kunzaatko> --
  -- 'TimUntersberger/neogit' -- magit for neovim {{{
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    keys = utils.get_multi_keys { { 'n', { { '<leader>g' }, { 'g', 'c' } } }, { 'n', '<leader>G' } },
    requires = 'sindrets/diffview.nvim',
    setup = function()
      local wk = require 'which-key'
      wk.register({
        g = {
          name = 'NeoGit',
          g = { 'open' },
          c = { 'commit pop-up' },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'NeogitStatus,NeogitPopup',
        desc = ' No spell, list and fold in Neogit',
        callback = function()
          vim.opt_local.list = false
          vim.opt_local.spell = false
          vim.opt_local.foldlevel = 1000
        end,
      })
      require('neogit').setup {
        disable_hint = true,
        disable_builtin_notifications = true,
        disable_commit_confirmation = true,
        commit_popup = { kind = 'vsplit' },
        integrations = { diffview = true },
      }
      -- TODO: Do this with which-key <03-03-22, kunzaatko> --
      map('n', '<leader>gg', function()
        return require('neogit').open()
      end, { silent = true, desc = 'open Neogit' })
      map('n', '<leader>G', function()
        return require('neogit').open()
      end, { silent = true, desc = 'open Neogit' })
      map('n', '<leader>gc', function()
        return require('neogit').open { 'commit' }
      end, { silent = true, desc = 'open Neogit commit split' })
    end,
  },
  -- }}}

  -- 'lewis6991/gitsigns.nvim' -- signs of changes in sign column {{{
  {
    'lewis6991/gitsigns.nvim',
    as = 'gitsigns',
    event = 'BufRead',
    requires = 'nvim-lua/plenary.nvim',
    setup = function()
      vim.cmd 'packadd plenary.nvim'
      local wk = require 'which-key'
      wk.register({
        h = {
          name = 'Hunk',
          b = { 'Blame line' },
          p = { 'Preview hunk' },
          R = { 'Reset buffer' },
          r = { 'Reset hunk' },
          s = { 'Stage hunk' },
          S = { 'Stage buffer' },
          u = { 'Undo stage hunk' },
          U = { 'Reset buffer index' },
        },
      }, { prefix = '<leader>' })
      wk.register { [']c'] = { 'Next hunk' }, ['[c'] = { 'Prev hunk' } }
    end,
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { hl = 'GreenSign', text = '┃', numhl = 'GitSignsAddNr' },
          change = { hl = 'YellowSign', text = '┇', numhl = 'GitSignsChangeNr' },
          delete = { hl = 'RedSign', text = '┻', numhl = 'GitSignsDeleteNr' },
          topdelete = { hl = 'RedSign', text = '┳', numhl = 'GitSignsDeleteNr' },
          -- TODO: This should be probably deleted <12-03-22, kunzaatko> --
          changedelete = {
            hl = 'PurpleSign',
            text = '│',
            numhl = 'GitSignsChangeNr',
          },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = 'go to next hunk' })
          map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = 'go to prev hunk' })

          -- Actions
          map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'stage hunk' })
          map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo hunk staging' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview hunk' })
          map('n', '<leader>hb', function()
            gs.blame_line { full = true }
          end, { desc = 'blame line' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle blame current line' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'diff of line' })
          map('n', '<leader>hD', function()
            gs.diffthis '~'
          end)
          map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle deleted' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'inside hunk' })
        end,
      }
    end,
  },
  -- }}}

  -- FIX: Currently there is a missing font item in reactions on comments <12-12-21, kunzaatko> --
  -- 'pwntester/octo.nvim' -- github nvim UI {{{
  {
    'pwntester/octo.nvim',
    as = 'octo',
    keys = utils.get_keys('n', { { '<leader>o' }, { 'il', 'ic', 'rl', 'pl', 'pc' } }),
    setup = function()
      local wk = require 'which-key'
      wk.register({
        o = {
          name = 'Octo',
          i = {
            name = 'Issue',
            l = { 'List' },
            c = { 'Create' },
          },
          r = {
            name = 'Repo',
            l = {
              'List',
            },
          },
          p = {
            name = 'PullRequest',
            l = { 'List' },
            c = { 'Create' },
          },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      vim.cmd [[packadd telescope.nvim]]
      require('octo').setup {
        default_remote = { 'upstream', 'origin', 'github' },
        reaction_viewer_hint_icon = '',
        user_icon = ' ',
        timeline_marker = ' ',
      }
      -- TODO: Set through which-key <12-03-22, kunzaatko> --
      map('n', '<leader>oil', '<Cmd>Octo issue list<CR>', { silent = true, desc = 'list issues' })
      map('n', '<leader>oic', '<Cmd>Octo issue create<CR>', { silent = true, desc = 'create issue' })
      map('n', '<leader>orl', '<Cmd>Octo repo list<CR>', { silent = true, desc = 'list repositories' })
      map('n', '<leader>opl', '<Cmd>Octo pr list<CR>', { silent = true, desc = 'list pull-requests' })
      map('n', '<leader>opc', '<Cmd>Octo pr create<CR>', { silent = true, desc = 'create pull-request' })
    end,
    requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
  },
  -- }}}
}

return M
