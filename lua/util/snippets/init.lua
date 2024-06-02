_G.luasnip = {}
_G.luasnip.vars = {
  username = 'kunzaatko',
  email = 'martinkunz@email.cz',
  github = 'https://github.com/kunzaatko',
  real_name = 'Martin Kunz',
  date_format = '%d-%m-%y',
}
_G.luasnip._cache = {}

local M = {}

M = vim.tbl_extend('error', M, require 'util.snippets.comment')
M = vim.tbl_extend('error', M, require 'util.snippets.treesitter')

M.tex = require 'util.snippets.tex'

return M
