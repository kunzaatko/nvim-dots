local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local r = ls.restore_node
local fmta = require('luasnip.extras.fmt').fmta
local in_document = require('snippets.tex.utils').conditions.in_document

table.insert(
  M.autosnippets,
  s(
    { trig = 'mk', name = 'inline math', dscr = 'add inline math delimiters', docstring = { [[\({1}\)]], [[${1}$]] } },
    c(1, { fmta([[\(<>\)]], r(1, 'inline_math', i(1))), fmta([[$<>$]], r(1, 'inline_math')) }),
    { condition = in_document }
  )
)

table.insert(
  M.autosnippets,
  s(
    { trig = 'dm', name = 'displayed math', dscr = 'add displayed math delimiters', docstring = [[ \[{1}\] ]] },
    fmta(
      [[\[
    <>
\] ]],
      i(1)
    ),
    { condition = in_document }
  )
)

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_environments' })
