local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

-- map utilities
_G.MUtils = {}
local MUtils = _G.MUtils

-- leaders --

map('n', '<Space>', '<Nop>', {noremap = true}) -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

--  normal  --

MUtils.append_blanks = function()
  vim.fn.append(vim.fn.line("."),
                vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))
end
map('n', '<CR>', '<Cmd>lua _G.MUtils.append_blanks()<CR>',
    {noremap = true, silent = true}) -- N<CR> to append N blank lines below cursor
map('n', 'Y', 'y$', {noremap = true}) -- Y to act as D and C

-- visual --

map('v', '>>', '>><Esc>gv', {noremap = true}) -- reselect after >>
map('v', '<<', '<<<Esc>gv', {noremap = true}) -- reselect after <<

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
