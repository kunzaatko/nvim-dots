-- TODO: use 'brianhuster/unnest.nvim' when it allows to open the file in the current split
return { -- 'willothy/flatten.nvim': When opening a file in the terminal, uses the current neovim session to open the file instead
  'willothy/flatten.nvim',
  opts = {
    window = {
      open = 'alternate',
    },
  },
  lazy = false,
  priority = 1001,
}
