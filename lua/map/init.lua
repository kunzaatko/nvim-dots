local map = vim.api.nvim_set_keymap
local cmd = vim.cmd
require "utils.mutils"

-- leaders --

map('n', '<Space>', '<Nop>', { noremap = true }) -- this is needed before mapleader setting

vim.g.mapleader = ' ' -- global mappings leader
vim.g.maplocalleader = '-' -- leader for buffer local mapping

-- leader mappings --

map('n', '<leader>w', ':write<CR>', { noremap = true, silent = true })
map('n', '<leader>q', ':quit<CR>', { noremap = true, silent = true })
map('n', '<leader>wq', ':xit<CR>', { noremap = true, silent = true })

--  normal  --

map(
  'n', '<CR>', '<Cmd>lua MUtils.append_blank_lines()<CR>',
  { noremap = true, silent = true }
) -- N<CR> to append N blank lines below cursor
map('n', 'Y', 'y$', { noremap = true }) -- Y to act as D and C
map('n', 'p', 'p`]', { noremap = true, silent = true }) -- go to end of pasted text

-- visual --

map('v', '>>', '>><Esc>gv', { noremap = true }) -- reselect after >>
map('v', '<<', '<<<Esc>gv', { noremap = true }) -- reselect after <<
map('v', 'y', 'y`]', { noremap = true, silent = true }) -- go to end of yanked text
map('v', 'p', 'p`]', { noremap = true, silent = true }) -- go to end of pasted text

-- command --

map('c', 'w!!', '<Cmd>lua MUtils.save_root()<CR>', { noremap = true }) -- writing read-only files

-- NOTE: Needed for managing packer as an opt plugin <kunzaatko> --
-- NOTE: Installing spec plugins without needing to have packer loaded <kunzaatko> --
cmd [[
    command! -nargs=* -complete=customlist,v:lua.require'packer'.plugin_complete  PackerInstall lua MUtils.packer_install(<f-args>)
]] -- install plugins <f-args> or spec plugins for no <f-args>
cmd [[
    command! -nargs=* -complete=customlist,v:lua.require'packer'.plugin_complete PackerUpdate lua MUtils.packer_update(<f-args>)
]] -- update plugins <f-args> or spec plugins for no <f-args>
cmd [[
    command! -nargs=* -complete=customlist,v:lua.require'packer'.plugin_complete PackerSync lua MUtils.packer_sync(<f-args>)
]] -- sync plugins <f-args> or spec plugins for no <f-args>
cmd [[
  command! PackerClean packadd packer.nvim | lua require('pkg.install_packer');require('pkg').clean()
]] -- clean configuration
cmd [[
  command! PackerCompile packadd packer.nvim | lua require('pkg.install_packer');require('pkg').compile()
]] -- compile packer spec
cmd [[
  command! -bang -nargs=+ -complete=customlist,v:lua.require'packer'.loader_complete PackerLoad lua require('pkg.install_packer');require('packer').loader(<f-args>, '<bang>')
]] -- load plugins

-- TODO: Fix profiling issue (what does wbthomason have in his config) <17-11-21, kunzaatko> --
cmd [[
  command! PackerProfile packadd packer.nvim | lua require'packer'.profile_output()
]] -- profiling window
