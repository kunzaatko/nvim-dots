local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

-- map utilities
_G.MUtils = {}
local MUtils = _G.MUtils

-- leaders --

map('n', '<Space>', '<Nop>', {noremap = true}) -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

-- leader mappings --

map('n', '<Leader>w', ':write<CR>', {noremap = true, silent = true})
map('n', '<Leader>q', ':quit<CR>', {noremap = true, silent = true})
map('n', '<Leader>wq', ':wq<CR>', {noremap = true, silent = true})

--  normal  --

MUtils.append_blank_lines = function()
  vim.fn.append(vim.api.nvim_get_current_line(),
                vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))
end
map('n', '<CR>', '<Cmd>lua _G.MUtils.append_blank_lines()<CR>',
    {noremap = true, silent = true}) -- N<CR> to append N blank lines below cursor
map('n', 'Y', 'y$', {noremap = true}) -- Y to act as D and C
map('n', 'p', 'p`]', {noremap = true, silent = true}) -- go to end of pasted text

-- visual --

map('v', '>>', '>><Esc>gv', {noremap = true}) -- reselect after >>
map('v', '<<', '<<<Esc>gv', {noremap = true}) -- reselect after <<
map('v', 'y', 'y`]', {noremap = true, silent = true}) -- go to end of yanked text
map('v', 'p', 'p`]', {noremap = true, silent = true}) -- go to end of pasted text

-- command --

-- TODO: Does not work <09-05-21, kunzaatko> --
MUtils.save_root = function()
  vim.fn.execute("silent! write !sudo tee % >/dev/null | edit!<CR>")
end
map('c', 'w!!', '<Cmd>lua _G.MUtils.save_root()<CR>', {noremap = true}) -- writing read-only files

cmd [[
    command! PackerInstall exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').install()
    command! PackerUpdate exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').update()
    command! PackerSync exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').sync()
    command! PackerClean exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').clean()
    command! PackerCompile exe("lua require'pkg.install_packer'") | packadd packer.nvim | lua require('pkg').compile()
]] -- these are needed for having packer as an opt package
