return {
  {
    'glacambre/firenvim',
    build = function()
      vim.call['firenvim#install'](0)
    end,
    cond = function()
      return vim.fn.exists 'g:started_by_firenvim'
    end,
  },
  {
    'epwalsh/pomo.nvim',
    version = '*',
    lazy = true,
    cmd = { 'TimerStart', 'TimerStop', 'TimerRepeat' },
    opts = {
      notifiers = {
        {
          name = 'Default',
          opts = {
            sticky = false,
          },
        },
      },
    },
  },
  {
    'Hashino/doing.nvim',
    cmd = 'Do',
    -- NOTE: Lazy loading causes non-stop overwriting of the `.tasks` file <17-05-25>
    lazy = false,
    opts = {
      doing_prefix = '',
      show_remaining = false,
      edit_win_config = {
        width = 100,
      },
      winbar = { enabled = false },
      store = {
        file_name = '.tasks',
      },
    },
    keys = {
      {
        '<leader>da',
        function()
          require('doing').add()
        end,
        desc = 'Add task',
      },
      {
        '<leader>dn',
        function()
          require('doing').done()
        end,
        desc = 'Mark task done',
      },
      {
        '<leader>de',
        function()
          require('doing').edit()
        end,
        desc = 'Edit tasks',
      },
    },
  },
  {
    'krivahtoo/silicon.nvim',
    cmd = 'Silicon',
    name = 'silicon',
    build = './install.sh build',
    opts = {
      font = 'Fira Code',
      theme = 'Nord',
      output = {
        path = vim.uv.os_homedir() .. '/Pictures/Screenshots',
      },
      shadow = {
        blur_radius = 15.0,
        color = '#555',
      },
      pad_horiz = 30,
      pad_vert = 30,
      line_number = false,
      window_controls = false,
      window_title = function()
        return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ':~:.')
      end,
    },
    config = function(_, opts)
      require('silicon').setup(opts)
    end,
  },
  {
    'nullchilly/fsread.nvim',
    name = 'fsread',
    cmd = { 'FSRead', 'FSClear', 'FSToggle' },
  },
  {
    'xiyaowong/transparent.nvim',
    name = 'transparent',
    cmd = { 'TransparentEnable', 'TransparentDisable', 'TransparentToggle' },
    config = true,
  },
}
