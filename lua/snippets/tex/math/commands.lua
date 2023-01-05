local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local t = ls.text_node
local fmta = require('luasnip.extras.fmt').fmta

local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone

local capture_wrap_snippet = require('snippets.tex.utils').snippet_templates.capture_wrap_snippet

local auto_capture_specs = { --{{{
  [ [[([a-zA-Z])hat]] ] = {
    context = {
      name = 'hat',
      dscr = 'automatic hat command',
    },
    command = [[\hat]],
  },
  [ [[([a-zA-Z])vec]] ] = {
    context = {
      name = 'vec',
      dscr = 'automatic vec command',
    },
    command = [[\vec]],
  },
  [ [[([a-zA-Z])bar]] ] = {
    context = {
      name = 'bar',
      dscr = 'automatic overline command',
    },
    command = [[\bar]],
  },
}

local auto_capture_snippets = {}
for k, v in pairs(auto_capture_specs) do
  table.insert(
    auto_capture_snippets,
    capture_wrap_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_mathzone })
  )
end
vim.list_extend(M.autosnippets, auto_capture_snippets) --}}}

local simple_command_snippet = require('snippets.tex.utils').snippet_templates.simple_command_snippet

local simple_command_specs = { --{{{
  hat = {
    context = {
      name = 'hat',
      dscr = 'hat command',
    },
    command = [[\hat]],
  },
  vec = {
    context = {
      name = 'vec',
      dscr = 'vec command',
    },
    command = [[\vec]],
  },
  bar = {
    context = {
      name = 'bar',
      dscr = 'bar command',
    },
    command = [[\bar]],
  },
  tt = {
    context = {
      name = 'text',
      dscr = 'text field in math',
    },
    command = [[\text]],
  },
  sq = {
    context = {
      name = [[square root]],
      dscr = 'square root of argument',
    },
    command = [[\sqrt]],
  },
}

local simple_command_snippets = {}
for k, v in pairs(simple_command_specs) do
  table.insert(
    simple_command_snippets,
    simple_command_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_mathzone })
  )
end
vim.list_extend(M.autosnippets, simple_command_snippets) --}}}

local indexing_command_snippet = require('snippets.tex.utils').snippet_templates.indexing_command_snippet
local indexers = require('snippets.tex.utils').snippet_parts.indexers

local command_snippets_auto = { --{{{
  s(
    {
      -- FIX:  This will not work for a numberator that includes a paren
      trig = [[%((.*)%)/]],
      name = 'fracion of ({capture})',
      docstring = [[\frac{{capture}}{{1}}{0}]],
      dscr = 'wrap expresion in () in a fraction command',
      regTrig = true,
      wordTrig = false,
    },
    fmta([[\frac{<>}{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end), i(1) }),
    { condition = in_mathzone }
  ),
  -- TODO: add quad text snippet as in physics package
  s({
    trig = 'qq',
    name = 'quad space',
    dscr = 'quad space command',
  }, t [[\quad]], { condition = in_mathzone }),
}
vim.list_extend(M.autosnippets, command_snippets_auto) --}}}

local indexing_command_specs = { --{{{
  sum = {
    command = [[\sum]],
    indexes = { indexers.discrete_bound, indexers.discrete_set },
  },
  prod = {
    command = [[\prod]],
    indexes = { indexers.discrete_bound, indexers.discrete_set },
  },
  dint = {
    -- TODO: Add tail to command that will be determined by the indexing
    command = [[\int]],
    indexes = { indexers.continuous_bound, indexers.continuous_set },
  },
  nnn = {
    command = [[\bigcap]],
    indexes = { indexers.discrete_set, indexers.continuous_set, indexers.discrete_bound },
    auto = true,
  },
  uuu = {
    command = [[\bigcup]],
    indexes = { indexers.discrete_set, indexers.continuous_set, indexers.discrete_bound },
    auto = true,
  },
  -- lim
  -- limsup
  -- taylor
}

local indexing_command_snippets = {}
local indexing_command_snippets_auto = {}
for k, v in pairs(indexing_command_specs) do
  local snippet = indexing_command_snippet(
    vim.tbl_deep_extend('keep', { trig = k }, v.context or {}),
    v.command,
    v.indexes,
    { condition = in_mathzone }
  )
  if v.auto then
    table.insert(indexing_command_snippets_auto, snippet)
  else
    table.insert(indexing_command_snippets, snippet)
  end
end
vim.list_extend(M.snippets, indexing_command_snippets)
vim.list_extend(M.autosnippets, indexing_command_snippets_auto) --}}}

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_commands_auto' })
ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_math_commands' })
