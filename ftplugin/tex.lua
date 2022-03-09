local map = vim.api.nvim_set_keymap
require 'utils.texutils'

vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg' -- no s... do not conceal sub/sup scripts

map(
  'i',
  '<C-f>',
  '<Cmd>lua _G.MUtils.inkscape_figures_create(vim.api.nvim_get_current_line()) <CR>',
  { noremap = true, silent = true }
)
map('n', '<C-f>', '<Cmd>lua _G.MUtils.inkscape_figures_edit() <CR>', { noremap = true, silent = true })

vim.cmd [[
augroup KillFigureWatch
    autocmd!
    autocmd VimLeave * call v:lua.TEXUtils.kill_watch_daemon()
augroup END
]]
