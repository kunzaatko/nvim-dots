return {
  -- TODO: Add git-blame <10-06-23>
  {
    'lewis6991/gitsigns.nvim',
    name = 'gitsigns',
    dependencies = { 'nvim-lua/plenary.nvim', name = 'plenary' },
    event = 'BufReadPre',
    enabled = vim.fn.executable 'git' == 1,
    opts = {
      -- FIX: Defining the correct highlights such as `GitSignsChange` to yellow does not work?! What is the problem? <24-06-24>
      signs = {
        add = { text = '┃' },
        change = { text = '┇' },
        delete = { text = '┻' },
        topdelete = { text = '┳' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- TODO: should be the same as in astrovim <19-04-23>
        -- Navigation
        vim.keymap.set(
          'n',
          ']c',
          "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
          { expr = true, desc = 'go to next hunk', buffer = bufnr }
        )
        vim.keymap.set(
          'n',
          '[c',
          "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
          { expr = true, desc = 'go to prev hunk', buffer = bufnr }
        )

        -- Actions
        vim.keymap.set({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = 'stage hunk', buffer = bufnr })
        vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', { desc = 'reset hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { desc = 'stage buffer', buffer = bufnr })
        vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo hunk staging', buffer = bufnr })
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer, { desc = 'reset buffer', buffer = bufnr })
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = 'preview hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>gL', function()
          gs.blame_line { full = true }
        end, { desc = 'view full git blame', buffer = bufnr })
        vim.keymap.set('n', '<leader>gl', function()
          gs.blame_line {}
        end, { desc = 'view git blame', buffer = bufnr })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'diff of line', buffer = bufnr })
        vim.keymap.set('n', '<leader>gdd', function()
          gs.diffthis '~'
        end)
        vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, { desc = 'toggle deleted', buffer = bufnr })

        -- Text object
        vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'inside hunk', buffer = bufnr })
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    keys = { '<leader>gg', '<leader>gc' },
    event = 'VeryLazy',
    opts = {
      disable_hint = true,
      disable_builtin_notifications = true,
      disable_commit_confirmation = true,
      commit_popup = { kind = 'vsplit' },
      integrations = { diffview = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'NeogitStatus', 'NeogitPopup' },
        desc = ' No spell, list and fold in Neogit',
        callback = function()
          vim.opt_local.list = false
          vim.opt_local.spell = false
          vim.opt_local.foldlevel = 1000
        end,
      })
      vim.keymap.set('n', '<leader>gg', require('neogit').open, { desc = 'open Neogit' })
      vim.keymap.set('n', '<leader>gc', function()
        require('neogit').open { 'commit' }
      end, { desc = 'git commit' })
      require('neogit').setup(opts)
    end,
  },
  -- TODO: Add icons using the icons util <12-05-23>
  -- TODO: Change the diff colours not to overwrite the foreground colours <20-05-23>
  {
    'sindrets/diffview.nvim',
    keys = { '<leader>gD' },
    event = 'VeryLazy',
    cmd = 'DiffviewOpen',
    module = 'diffview',
    config = function()
      vim.keymap.set('n', '<leader>gD', '<Cmd>DiffviewOpen<CR>', { desc = 'open Diffview' })

      -- FIX: This is deprecated. Get the new method of setting callbacks in the README <22-08-22, kunzaatko>
      local cb = require('diffview.config').diffview_callback
      local map = vim.keymap.set
      _G.MUtils = _G.MUtils or {}
      _G.MUtils.close_diffview = function()
        vim.cmd [[tabclose]]
      end
      require('diffview').setup {
        key_bindings = {
          -- disable_defaults = true,
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
    end,
  },
  {
    'pwntester/octo.nvim',
    name = 'octo',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', name = 'telescope' },
      { 'kyazdani42/nvim-web-devicons', name = 'devicons' },
    },
    cmd = 'Octo',
    event = 'VeryLazy',
    opts = {
      default_remote = { 'upstream', 'origin', 'github' },
      reaction_viewer_hint_icon = '',
      user_icon = ' ',
      timeline_marker = ' ',
    },
    config = function(_, opts)
      vim.api.nvim_create_augroup('octo_settings', {})
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'octo://*',
        desc = 'Settings for the octo window',
        group = 'octo_settings',
        callback = function()
          local wk = require 'which-key'
          -- TODO: Add icons through icon util <04-05-23>
          wk.register({
            a = { name = 'Assignee' },
            c = { name = 'Comment' },
            r = { name = 'Reaction' },
            v = { name = 'Reviewer' },
            i = { name = 'Issues/Close' },
            l = { name = 'Label' },
            p = { name = 'PR actions' },
          }, { buffer = 0, prefix = '<leader>' })
        end,
      })
      require('octo').setup(opts)
    end,
  },
}
