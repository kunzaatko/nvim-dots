return { -- 'willothy/flatten.nvim': When opening a file in the terminal, uses the current neovim session to open the file instead
  'willothy/flatten.nvim',
  opts = {
    window = {
      open = 'vsplit',
    },
  },
  lazy = false,
  priority = 1001,
}
