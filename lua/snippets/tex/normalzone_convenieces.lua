local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local in_normalzone = require('snippets.tex.utils').conditions.in_normalzone

table.insert(
  M.autosnippets,
  s(
    { trig = '__', name = 'emphasize', dscr = 'Emphasize an argument', docstring = [[\emph{{1}}{0}]] },
    fmta([[\emph{<>} ]], i(1)),
    { condition = in_normalzone }
  )
)

local simple_command_snippet = require('snippets.tex.utils').snippet_templates.simple_command_snippet

table.insert(
  M.autosnippets,
  simple_command_snippet({ trig = 'lbl', dscr = 'Add label' }, '\\label', { condition = in_normalzone })
)

local auto_backslash_argument_command_snippet =
  require('snippets.tex.utils').snippet_templates.auto_backslash_argument_command_snippet

local auto_backslash_specs = { --{{{
  'ref',
}
local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
  table.insert(
    auto_backslash_snippets,
    auto_backslash_argument_command_snippet({ trig = v }, { condition = in_normalzone })
  )
end
vim.list_extend(M.autosnippets, auto_backslash_snippets) --}}}

ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_normalzone_conveniences' })
ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_normalzone_conveniences' })
