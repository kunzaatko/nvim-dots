-- TODO: Add '<leader>' window commands <16-01-22, kunzaatko> --
-- TODO: Add vsb command abbreviation for :vert sb <16-01-22, kunzaatko> --
-- TODO: Command for buffer tab (does it exist?). Same as `:sb` but `:tb` for tabnew <16-01-22, kunzaatko> --
local map = vim.keymap.set
local utils = require 'map.utils'

-- leaders --

map('n', '<Space>', '<Nop>') -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

-- leader mappings --

map('n', '<leader>w', ':write<CR>', { silent = true, desc = 'write buffer' })
map('n', '<leader>q', ':quit<CR>', { silent = true, desc = 'quit window' })
map('n', '<leader>wq', ':xit<CR>', { silent = true, desc = 'write and quit' })
map('n', '<leader>Q', ':qall<CR>', { silent = true, desc = 'exit' })
map('n', '<leader>wQ', ':xall<CR>', { silent = true, desc = 'write all and exit' })
map('n', '<leader>s', ':%s/', { desc = 'substitute' })
map('n', '<leader>S', ':%s/\\v', { desc = 'substitute with verymagic' })
-- map('n', '<leader><leader>', '/', { noremap = true })

-- TODO: Make this a lua function when it is possible <20-02-22, kunzaatko> --
-- _G.MUtils.search_for_visual = function()
--   local register_name = 'b'
--   vim.cmd('"' .. register_name .. 'y')
--   local selection = vim.api.nvim_call_function('getreg', { register_name, 1 })
--   vim.notify(selection)
--   vim.cmd('/' .. selection)
-- end

-- TODO: Do this using Telescope <13-03-22, kunzaatko> --
map('v', '<leader><leader>', '"by/<C-R>b', { desc = 'search VISUAL selection' })
map('n', ',,', ':', { desc = 'command line' })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('BufferModifiableMappings', {}),
  desc = 'Keymaps that are only applicable when the buffer is modifiable',
  callback = function()
    if vim.bo.modifiable == true then
      -- N<CR> to append N blank lines below cursor
      map('n', '<CR>', utils.append_blank_lines, { silent = true, desc = 'append bland lines', buffer = true })
    end
  end,
})

map('n', 'Y', 'y$', { desc = 'yank to <EOL>' }) -- Y to act as D and C
map({ 'n', 'v' }, 'p', 'p`]', { silent = true, desc = 'paste and go to end of pasted' }) -- go to end of pasted text

map('v', '>>', '>><Esc>gv', { desc = 'indent and reselect' }) -- reselect after >>
map('v', '<<', '<<<Esc>gv', { desc = 'dedent and reselect' }) -- reselect after <<
map('v', 'y', 'y`]', { silent = true, desc = 'yank and go to end of yanked' }) -- go to end of yanked text
map('v', '<leader>s', ':s/', { desc = 'substitute in VISUAL' })
map('v', '<leader>S', ':s/\\v', { desc = 'substitute in VISUAL with verymagic' })

-- command --

-- ISSUE: This does not work. Look at tpopes plugin, how it is achieved. <13-03-22, kunzaatko> --
map('c', 'w!!', utils.save_root, { desc = 'write as root' }) -- writing read-only files
map('c', 'vsb', 'vert sbuffer', { desc = 'vertical split buffer' }) -- vertical split buffer

-- TODO: Add autoregister, when the autoregistering is possible with whichkey <13-03-22, kunzaatko> --
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
