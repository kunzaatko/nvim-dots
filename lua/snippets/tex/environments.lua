local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local sn = ls.snippet_node
local c = ls.choice_node
local m = require('luasnip.extras').match
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local in_document = require('snippets.tex.utils').conditions.in_document
local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone
local simple_env_nodes = require('snippets.tex.utils').snippet_templates.simple_env_nodes

table.insert(
  M.autosnippets,
  s( -- \begin{}[] \end{} {{{
    {
      trig = 'beg',
      name = 'begin',
      dscr = 'Begin environment',
      docstring = [[
\begin{{1:environment}}[{2}]
  {3}
\end{{1}}{0}
]],
    },
    fmta(
      [[
    \begin{<>}<>
      <>
    \end{<>}<>
    ]],
      {
        i(1), -- environment name
        sn(2, { m(1, [[.+]], '[', ''), i(1), m(1, [[.+]], ']', '') }), -- optional arguments to environment
        i(3),
        rep(1),
        i(0),
      }
    ),
    { condition = in_document }
  ) --}}}
)

-- TODO: Add support for visual <21-03-22, kunzaatko>
local simple_env_snippet_node = function(envname, restore)
  return sn(1, simple_env_nodes(envname, restore))
end

local math_environments = { --{{{
  s({
    trig = 'ali',
    name = 'Align',
    dscr = 'Aligned math environment in math zone',
    docstring = [[
  \begin{aligned}
    {1}
  \end{aligned}{0}
  ]],
  }, simple_env_nodes 'aligned', { condition = in_mathzone }),
  s({
    trig = 'split',
    name = 'Split',
    dscr = 'Split environment in math zone',
    docstring = [[
  \begin{split}
    {1}
  \end{split}{0}
  ]],
  }, simple_env_nodes 'split', { condition = in_mathzone }),
  s(
    {
      trig = 'ali',
      name = 'Align',
      dscr = 'Align math environment choice',
      docstring = [[
  \begin{align|flalign|flalign*}
    {1}
  \end{align|flalign|flatign*}{0}
  ]],
    },
    c(1, {
      simple_env_snippet_node('align', 'math-align'),
      simple_env_snippet_node('flalign', 'math-align'),
      simple_env_snippet_node('flalign*', 'math-align'),
    }),
    { condition = in_document }
  ),
} --}}}
vim.list_extend(M.autosnippets, math_environments)

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_environments' })
