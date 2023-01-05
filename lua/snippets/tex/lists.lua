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
local fmta = require('luasnip.extras.fmt').fmta
local m = require('luasnip.extras').match
local f = ls.function_node

local in_normalzone = require('snippets.tex.utils').conditions.in_normalzone
local in_list = require('snippets.tex.utils').conditions.in_list

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

table.insert(
  M.snippets,
  s({ trig = 'ls', name = 'infinite list' }, {
    t { '\\begin{itemize}', '\t\\item ' },
    i(1),
    d(2, rec_ls, {}),
    t { '', '\\end{itemize}' },
    i(0),
  }, { condition = in_normalzone })
)

table.insert(
  M.autosnippets,
  s(
    {
      trig = 'enum',
      name = 'enumerate environment',
      dscr = 'Enumerate environment with options for the label',
      docstring = [[
    \begin{enumerate}[{1:label choice}]
      {2}
    \end{enumerate}
    ]],
    },
    fmta(
      [[
    \begin{enumerate}<>
      <>
    \end{enumerate}
    ]],
      {
        sn(1, {
          m(1, [[.+]], '[', ''),
          c(1, {
            t [[]],
            fmta([[<>label = <>)]], { i(1), c(2, { t [[\alph*)]], t [[(\alph*)]], t [[\alph*.]] }) }),
            fmta([[<>label = <>)]], { i(1), c(2, { t [[\roman*.]], t [[(\roman*)]], t [[\roman*)]] }) }),
            fmta([[<>label = <>)]], { i(1), c(2, { t [[\Roman*.]], t [[\Roman*)]], t [[(\Roman*)]] }) }),
          }),
          m(1, [[.+]], ']', ''),
        }), -- optional arguments to environment
        i(2),
      }
    ),
    { condition = in_normalzone }
  )
)

table.insert(
  M.autosnippets,
  -- TODO: add conditional label,
  s(
    {
      trig = [[^(%s*)-]],
      name = 'item',
      regTrig = true,
      dscr = 'item in list environment',
      docstring = [[\item {0}]],
    },
    f(function(_, snip)
      return snip.captures[1] .. [[\item]]
    end),
    { condition = in_list }
  )
)

ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_lists' })
ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_lists_auto' })
