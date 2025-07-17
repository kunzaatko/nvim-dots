return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>-',
      mode = { 'n', 'v' },
      '<cmd>Yazi toggle<cr>',
      desc = 'Open yazi at the current file',
    },
  },
}
