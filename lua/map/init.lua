local map = require'utils'.map


map('n', '<Space>', '<Nop>', {noremap = true}) -- this is needed before mapleader setting

vim.g.mapleader = ' '
vim.g.maplocalleader = '-' -- leader local to buffer (for buffer local mappings)

--  NORMAL  --
map('n', '<CR>',
    [[<Cmd>lua vim.fn.append(vim.fn.line("."), vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))<CR>]],
    {silent = true}) -- N<CR> to add N lines below cursor
map('n', 'Y', 'y$', {noremap = true}) -- Y to act as D and C

-- VISUAL --
map('v', '>>', '>><Esc>gv', {noremap = true}) -- reselect after >>
map('v', '<<', '<<<Esc>gv', {noremap = true}) -- reselect after <<

-- COMMAND--
map('c', 'w!!',
    [[<Cmd>lua vim.fn.execute("silent! write !sudo tee % >/dev/null") <bar> edit!<CR>]],
    {noremap = true}) -- writing read-only files
