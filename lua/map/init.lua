-- TODO: Add '<leader>' window commands <16-01-22, kunzaatko> --
-- TODO: Add vsb command abbreviation for :vert sb <16-01-22, kunzaatko> --
-- TODO: Command for buffer tab (does it exist?). Same as `:sb` but `:tb` for tabnew <16-01-22, kunzaatko> --
local map = vim.keymap.set
-- local cmd = vim.cmd
require 'utils.mutils'

-- leaders --

map('n', '<Space>', '<Nop>') -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

-- leader mappings --

map('n', '<leader>w', ':write<CR>', { silent = true })
map('n', '<leader>q', ':quit<CR>', { silent = true })
map('n', '<leader>wq', ':xit<CR>', { silent = true })
map('n', '<leader>Q', ':qall<CR>', { silent = true })
map('n', '<leader>wQ', ':xall<CR>', { silent = true })
map('n', '<leader>s', ':%s/')
map('n', '<leader>S', ':%s/\\v')
-- map('n', '<leader><leader>', '/', { noremap = true })

-- TODO: Make this a lua function when it is possible <20-02-22, kunzaatko> --
-- _G.MUtils.search_for_visual = function()
--   local register_name = 'b'
--   vim.cmd('"' .. register_name .. 'y')
--   local selection = vim.api.nvim_call_function('getreg', { register_name, 1 })
--   vim.notify(selection)
--   vim.cmd('/' .. selection)
-- end
map('v', '<leader><leader>', '"by/<C-R>b')
map('n', ',,', ':')

--  normal  --

map('n', '<CR>', _G.MUtils.append_blank_lines, { silent = true }) -- N<CR> to append N blank lines below cursor
map('n', 'Y', 'y$') -- Y to act as D and C
map('n', 'p', 'p`]', { silent = true }) -- go to end of pasted text

-- visual --

map('v', '>>', '>><Esc>gv') -- reselect after >>
map('v', '<<', '<<<Esc>gv') -- reselect after <<
map('v', 'y', 'y`]', { silent = true }) -- go to end of yanked text
map('v', 'p', 'p`]', { silent = true }) -- go to end of pasted text
map('v', '<leader>s', ':s/')
map('v', '<leader>S', ':s/\\v')

-- command --

map('c', 'w!!', _G.MUtils.save_root) -- writing read-only files
map('c', 'vsb', 'vert sbuffer') -- vertical split buffer

local wk = require 'which-key'
wk.register {
  ['<leader>w'] = { 'Write' },
  ['<leader>q'] = { 'Quit' },
  ['<leader>wq'] = { 'Xit' },
  ['<leader>Q'] = { 'Quit all' },
  ['<leader>wQ'] = { 'Xit all' },
  ['<leader>s'] = { 'Substitute' },
  ['<leader>S'] = { 'Substitute verymagic' },
  ['<leader><leader>'] = { 'Search' },
  [',,'] = { 'Command line' },
}
