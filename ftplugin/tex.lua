local map = vim.api.nvim_set_keymap
require 'utils.texutils'

vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg' -- no s... do not conceal sub/sup scripts

map(
  'i',
  '<C-f>',
  'v:lua.MUtils.inkscape_figures_create(vim.api.nvim_get_current_line())',
  { expr = true, noremap = true, silent = true }
)
map('n', '<C-f>', 'v:lua.MUtils.inkscape_figures_edit()', { expr = true, noremap = true, silent = true })

-- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
vim.cmd [[
augroup KillFigureWatch
    autocmd!
    autocmd VimLeave * call v:lua.TEXUtils.kill_watch_daemon()
augroup END
]]
