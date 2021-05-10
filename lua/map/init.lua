local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

-- map utilities
_G.MUtils = {}
local MUtils = _G.MUtils

-- leaders --

map('n', '<Space>', '<Nop>', {noremap = true}) -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

--  NORMAL  --
map('n', '<CR>',
    [[<Cmd>lua vim.fn.append(vim.fn.line("."), vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))<CR>]],
    {silent = true}) -- N<CR> to add N lines below cursor
map('n', 'Y', 'y$', {noremap = true}) -- Y to act as D and C

-- visual --

map('v', '>>', '>><Esc>gv', {noremap = true}) -- reselect after >>
map('v', '<<', '<<<Esc>gv', {noremap = true}) -- reselect after <<

-- command --
map('c', 'w!!',
    [[<Cmd>lua vim.fn.execute("silent! write !sudo tee % >/dev/null") <bar> edit!<CR>]],
    {noremap = true}) -- writing read-only files


vim.cmd [[command! PackerInstall exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').install()]]
vim.cmd [[command! PackerUpdate exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').update()]]
vim.cmd [[command! PackerSync exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').sync()]]
vim.cmd [[command! PackerClean exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').clean()]]
vim.cmd [[command! PackerCompile exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').compile()]]
