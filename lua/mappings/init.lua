require 'mappings.helper'

local g, fn, api = vim.g, vim.fn, vim.api
local map = api.nvim_set_keymap()

g.mapleader = '<Space>'
g.maplocalleader = '-' -- leader local to buffer (for buffer local mappings)

--  NORMAL  --
map('n', '<CR>',
    ([[vim.fn.append(vim.fn.line("."), vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))]]):is_cmd{
  lua = true,
}, {silent = true}) -- N<CR> to add N lines below cursor
map('n', 'Y', 'y$', {noremap = true}) -- Y to act as D and C

-- VISUAL --
map('v', '>>', '>><Esc>gv', {noremap = true}) -- reselect after >>
map('v', '<<', '<<<Esc>gv', {noremap = true}) -- reselect after <<

-- COMMAND--
map('c', 'w!!',
    ([[vim.fn.execute("silent! write !sudo tee % >/dev/null") <bar> edit!]]):is_cmd{
  lua = true,
}, {noremap = true}) -- writing read-only files
