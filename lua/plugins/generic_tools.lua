return {
  {
    'glacambre/firenvim',
    build = function()
      vim.fn['firenvim#install'](0)
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
    dependencies = {
      'notify',
    },
    after = 'notify',
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
    'krivahtoo/silicon.nvim',
    cmd = 'Silicon',
    name = 'silicon',
    build = './install.sh build',
    opts = {
      font = 'Fira Code',
      theme = 'Nord',
      output = {
        path = '/home/krivah/Pictures/Screenshots',
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
