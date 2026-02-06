return {
  -- TODO: Add git-blame <10-06-23>
  {
    'lewis6991/gitsigns.nvim',
    name = 'gitsigns',
    dependencies = { { 'nvim-lua/plenary.nvim', name = 'plenary' } },
    event = 'BufReadPre',
    enabled = vim.fn.executable 'git' == 1,
    opts = {
      -- FIX: Defining the correct highlights such as `GitSignsChange` to yellow does not work?! What is the problem?
      -- <24-06-24>
      signs = {
        add = { text = '┃' },
        change = { text = '┇' },
        delete = { text = '┻' },
        topdelete = { text = '┳' },
        changedelete = { text = '▎' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, { desc = 'next hunk', buffer = bufnr })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, { desc = 'previous hunk', buffer = bufnr })

        -- Actions
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'stage hunk', buffer = bufnr })
        vim.keymap.set('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage hunk', buffer = bufnr })
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'reset hunk', buffer = bufnr })
        vim.keymap.set('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset hunk', buffer = bufnr })
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
        vim.keymap.set('n', '<leader>gQ', function()
          gs.setqflist 'all'
        end, { desc = 'hunks to quickfix list', buffer = bufnr })
        vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, { desc = 'toggle deleted', buffer = bufnr })

        -- Text object
        vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'inside hunk', buffer = bufnr })
      end,
    },
  },
  -- TODO: Open neogit in a floating window instead of new buffer. <21-09-24>
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    keys = { '<leader>gg', '<leader>gc' },
    event = 'VeryLazy',
    opts = {
      disable_hint = true,
      graph_style = 'unicode',
      process_spinner = true,
      disable_commit_confirmation = true,
      signs = {
        hunk = { '', '' },
        item = { '', '' },
        section = { '', '' },
      },
      commit_editor = { kind = 'vsplit' },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'NeogitStatus', 'NeogitPopup' },
        desc = 'No list and fold in Neogit',
        callback = function()
          vim.opt_local.list = false
          vim.opt_local.foldlevel = 1000
          vim.opt_local.colorcolumn = { 0 }
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
  -- TODO: Add a window-line to indicate 'OURS', 'THEIRS', 'LOCAL' in the diffview <06-07-25>
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
  -- TODO: Open new issue in a floating window instead of new buffer. <21-09-24>
  {
    'pwntester/octo.nvim',
    name = 'octo',
    enabled = vim.fn.executable 'gh' == 1,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', name = 'devicons' },
      'folke/snacks.nvim',
    },
    cmd = 'Octo',
    event = 'VeryLazy',
    opts = {
      default_remote = { 'upstream', 'origin', 'github' },
      picker = 'snacks',
      reaction_viewer_hint_icon = static.icons.diagnostics.Hint,
      user_icon = static.icons.git.user,
      timeline_marker = static.icons.undotree.node,
    },
    config = function(_, opts)
      vim.treesitter.language.register('markdown', 'octo')
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'octo',
        desc = 'Do not autofold by textwidth in octo issues and pull requests',
        callback = function()
          vim.opt_local.formatoptions = {}
        end,
      })
      require('octo').setup(opts)
    end,
  },
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    keys = {
      {
        '<leader>gy',
        function()
          require('gitlinker').link()
        end,
        mode = { 'v', 'n' },
        silent = true,
        noremap = true,
        desc = 'Yank git permlink',
      },
    },
    config = function()
      local which_key_exists, _ = pcall(require, 'which-key')
      if which_key_exists then
        local wk = require 'which-key'
        -- FIX: Setting the icon here in which key does not work <29-03-25>
        wk.add { '<leader>gy', icon = static.icons.link }
      end
      require('gitlinker').setup()
    end,
  },
}
