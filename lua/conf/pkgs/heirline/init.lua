local utils = require 'heirline.utils'
require 'conf.pkgs.heirline.utils'

utils.setup_colors()
vim.api.nvim_create_augroup('Heirline', {})
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    utils.setup_colors()
    local statusline = require 'conf.pkgs.heirline'
    require('heirline').setup(statusline)
  end,
  group = 'Heirline',
})

local terminal = require 'conf.pkgs.heirline.lines.terminal'
local help = require 'conf.pkgs.heirline.lines.help'
local main = require 'conf.pkgs.heirline.lines.main'
local tree = require 'conf.pkgs.heirline.lines.tree'

-- TODO: Add specific status lines for buf types
-- {'packer', 'neogit', 'neogitcommint', 'diff',
-- 'trouble','startify','helpfile','diffview','undotree', 'startuptime', 'octo', 'toggleterm',
-- 'terminal', 'tsplayground', 'query'
-- }
-- <16-01-22, kunzaatko> --
local StatusLines = {
  fallthrough = false,
  help[1],
  help[2],
  terminal[1],
  terminal[2],
  tree[1],
  tree[2],
  main[1],
  main[2],
}

return StatusLines
