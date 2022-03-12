local M = {
  -- TODO: configure <03-03-22, kunzaatko> --
  -- 'TimUntersberger/neogit' -- magit for neovim {{{
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    keys = { '<leader>gg', '<leader>gc' },
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
      -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
      --luacheck: no max line length
      vim.cmd [[
        autocmd FileType NeogitStatus,NeogitPopup lua vim.opt_local.spell = false; vim.opt_local.list = false; vim.opt_local.foldlevel = 1000
        ]]
      --luacheck: max line length 120
      require('neogit').setup {
        disable_hint = true,
        disable_builtin_notifications = true,
        disable_commit_confirmation = true,
        commit_popup = { kind = 'vsplit' },
        integrations = { diffview = true },
      }
      -- TODO: Do this with which-key <03-03-22, kunzaatko> --
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gg',
        "<Cmd> lua require'neogit'.open()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>gc',
        "<Cmd> lua require'neogit'.open({'commit'})<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
  -- }}}
  -- 'sindrets/diffview.nvim' -- viewing diff of files in tree {{{
  {
    'sindrets/diffview.nvim',
    config = function()
      local MUtils = _G.MUtils
      local cb = require('diffview.config').diffview_callback
      MUtils.close_diffview = function()
        vim.cmd [[tabclose]]
      end
      require('diffview').setup {
        key_bindings = {
          disable_defaults = true,
          view = {
            ['q'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<esc>'] = '<Cmd>lua _G.MUtils.close_diffview()<CR>',
            ['<leader><leader>'] = cb 'toggle_files',
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
    end,
  },
  -- }}}
  -- 'lewis6991/gitsigns.nvim' -- signs of changes in sign column {{{
  {
    'lewis6991/gitsigns.nvim',
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
          changedelete = {
            hl = 'PurpleSign',
            text = '│',
            numhl = 'GitSignsChangeNr',
          },
        },
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
          end

          -- Navigation
          map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

          -- Actions
          map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
          map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
          map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
          map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
          map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
          map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
          map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
          map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
          map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

          -- Text object
          map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        -- TODO: Uncomment when vim.keymap.set is introduced with nvim v0.7 <03-03-22, kunzaatko> --
        -- on_attach = function(bufnr)
        --   local gs = package.loaded.gitsigns

        --   local function map(mode, l, r, opts)
        --     opts = opts or {}
        --     opts.buffer = bufnr
        --     vim.keymap.set(mode, l, r, opts)
        --   end

        --   -- Navigation
        --   map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
        --   map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

        --   -- Actions
        --   map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        --   map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        --   map('n', '<leader>hS', gs.stage_buffer)
        --   map('n', '<leader>hu', gs.undo_stage_hunk)
        --   map('n', '<leader>hR', gs.reset_buffer)
        --   map('n', '<leader>hp', gs.preview_hunk)
        --   map('n', '<leader>hb', function()
        --     gs.blame_line { full = true }
        --   end)
        --   map('n', '<leader>tb', gs.toggle_current_line_blame)
        --   map('n', '<leader>hd', gs.diffthis)
        --   map('n', '<leader>hD', function()
        --     gs.diffthis '~'
        --   end)
        --   map('n', '<leader>td', gs.toggle_deleted)

        --   -- Text object
        --   map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        -- end,
      }
    end,
  },
  -- }}}
  -- FIX: Currently there is a missing font item in reactions on comments <12-12-21, kunzaatko> --
  -- 'pwntester/octo.nvim' -- github nvim UI {{{
  {
    'pwntester/octo.nvim',
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
      vim.cmd [[packadd telescope.nvim]]
      require('octo').setup {
        default_remote = { 'upstream', 'origin', 'github' },
        reaction_viewer_hint_icon = '',
        user_icon = ' ',
        timeline_marker = ' ',
      }
      vim.api.nvim_set_keymap('n', '<leader>oil', '<Cmd>Octo issue list<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>oic', '<Cmd>Octo issue create<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>orl', '<Cmd>Octo repo list<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>opl', '<Cmd>Octo pr list<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>opc', '<Cmd>Octo pr create<CR>', { noremap = true, silent = true })
    end,
    requires = { 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons' },
  },
  -- }}}
}

return M