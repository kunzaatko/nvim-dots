-- NOTE: This file is not sourced <29-09-22>
local M = {
  autosnippets = {},
  snippets = {},
}
local ls = require 'luasnip'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node

-- FIX: this does not work currently --
-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
  return sn(
    nil,
    c(1, {
      -- Order is important, sn(...) first would cause infinite loop of expansion.
      t '',
      sn(nil, { t { '', '\t\\item ' }, i(1), d(2, rec_ls, {}) }),
    })
  )
end

ls.add_snippets('tex', {
  s('ls', {
    t { '\\begin{itemize}', '\t\\item ' },
    i(1),
    d(2, rec_ls, {}),
    t { '', '\\end{itemize}' },
    i(0),
  }),
}, { type = 'snippets', key = 'latex_lists' })
