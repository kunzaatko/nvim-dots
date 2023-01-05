local map = vim.keymap.set
local utils = require 'utils.tex'

vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg' -- no s... do not conceal sub/sup scripts

map('i', '<C-f>', function()
  local figname = vim.api.nvim_get_current_line()
  vim.api.nvim_del_current_line()
  utils.inkscape_figures_create(figname)
end, { desc = 'create an incscape figure' })
map('n', '<C-f>', utils.inkscape_figures_edit, { desc = 'edit an incscape figure' })

map('n', '<localleader>w', utils.COMPILERS.tectonic.watch, { desc = 'watch for changes and compile on write' })

map('n', '<localleader>b', utils.COMPILERS.tectonic.build, { desc = 'build document' })

map('n', '<localleader>o', function()
  utils.openpdf('zathura', utils.COMPILERS.tectonic.output())
end, { desc = 'open output with viewer' })

map('n', '<localleader>iw', utils.inkscape_figures_watch, { desc = 'start the watch daemon' })
map('n', '<localleader>is', utils.inkscape_shortcut_manager, { desc = 'start the shortcut manager' })

-- -- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
-- vim.cmd [[
-- augroup KillFigureWatch
--     autocmd!
--     autocmd VimLeave * call v:lua.TEXUtils.kill_watch_daemon()
-- augroup END
-- ]]

-- TODO: Add convenience mapping to edit global snippets <21-03-22>
