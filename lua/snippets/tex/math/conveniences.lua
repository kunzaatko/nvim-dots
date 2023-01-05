local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local f = ls.function_node
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

local after_math_variable = require('snippets.tex.utils').conditions.after_math_variable
local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone

local sup_sub_snippets = { --{{{
  s(
    { trig = 'invs', name = 'inverse', dscr = 'Add inverse exponent', docstring = '^{-1}{0}', wordTrig = false },
    { t [[^{-1}]] },
    { condition = after_math_variable }
  ),
  -- TODO: Should be a different symbol probably <20-03-22>
  s(
    { trig = 'compl', name = 'complement', dscr = 'Add complement exponent', docstring = '^{c}{0}', wordTrig = false },
    { t [[^{c}]] },
    { condition = after_math_variable }
  ),
  s(
    {
      trig = '([a-zA-Z])(%d)',
      dscr = 'Automatically add a subscript',
      name = 'auto-subscript',
      docstring = [[{capture:[a-zA-Z]}_{capture(%d)}]],
      regTrig = true,
      wordTrig = false,
    },
    f(function(_, snip)
      return snip.captures[1] .. '_' .. snip.captures[2]
    end),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '([a-zA-Z])_(%d%d+)',
      dscr = 'Automatically add a subscript',
      name = 'auto-subscript',
      docstring = [[{capture:[a-zA-Z]}_{{capture(%d)}}]],
      regTrig = true,
      wordTrig = false,
    },
    f(function(_, snip)
      return snip.captures[1] .. '_{' .. snip.captures[2] .. '}'
    end),
    { condition = in_mathzone }
  ),
  s(
    {--[[ TODO:  Check that I use this only in these situations ]]
      trig = '([a-zA-Z%d])__', -- regTrig assures that it is after a math variable
      name = 'manual subscript',
      dscr = 'Subscript',
      docstring = [[_{{1}}{0}]],
      regTrig = true,
      wordTrig = false,
    },
    fmta([[<>_{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end), i(1) }),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '([a-zA-Z%d])sr',
      name = '^2',
      docstring = '^2{0}',
      dscr = 'variable squared',
      wordTrig = false,
      regTrig = true,
    },
    f(function(_, snip)
      return snip.captures[1] .. '^2'
    end),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '([a-zA-Z%d])cb',
      name = '^3',
      docstring = '^3{0}',
      dscr = 'variable cubed',
      wordTrig = false,
      regTrig = true,
    },
    f(function(_, snip)
      return snip.captures[1] .. '^3'
    end),
    { condition = in_mathzone }
  ),
  s(
    {
      trig = '([a-zA-Z%d])td',
      name = 'to the power',
      docstring = '^{1}{0}',
      dscr = 'variable to the power of',
      wordTrig = false,
      regTrig = true,
    },
    fmta([[<>^{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end), i(1) }),
    { condition = in_mathzone }
  ),
}
vim.list_extend(M.autosnippets, sup_sub_snippets) --}}}

local auto_backslash_snippet = require('snippets.tex.utils').snippet_templates.auto_backslash_snippet

local auto_backslash_specs = { --{{{
  'sin',
  'cos',
  'tan',
  'arccot',
  'cot',
  'csc',
  'ls',
  'log',
  'exp',
  'star',
  'perp',
}
local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
  table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = in_mathzone }))
end
vim.list_extend(M.autosnippets, auto_backslash_snippets) --}}}

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_convieniences' })
