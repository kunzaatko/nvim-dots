local map = vim.api.nvim_set_keymap

map(
  'n', '<ScrollWheelUp>', [[<Cmd> lua vim.call'comfortable_motion#flick(-20)<CR>']],
  { silent = true }
)
map(
  'n', '<ScrollWheelDown>', [[<Cmd> lua vim.call'comfortable_motion#flick(20)<CR>']],
  { silent = true }
)
