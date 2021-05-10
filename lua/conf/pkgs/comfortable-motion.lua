local map = vim.api.nvim_set_keymap

vim.g.comfortable_motion_friction = 70.0
vim.g.comfortable_motion_air_drag = 3.0

map('n', '<ScrollWheelUp>', [[<Cmd> lua vim.call'comfortable_motion#flick(-20)<CR>']],
    {silent = true})
map('n', '<ScrollWheelDown>', [[<Cmd> lua vim.call'comfortable_motion#flick(20)<CR>']],
    {silent = true})
