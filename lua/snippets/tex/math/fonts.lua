local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone

local capture_wrap_snippet = require('snippets.tex.utils').snippet_templates.capture_wrap_snippet
local auto_capture_specs = { --{{{
  [ [[([a-zA-Z0-9])mbb]] ] = {
    context = {
      name = 'mathbb',
      dscr = 'Auto mathbb style',
    },
    command = [[\mathbb]],
  },
  [ [[([a-zA-Z0-9])mscr]] ] = {
    context = {
      name = 'mathscr',
      dscr = 'Auto mathscr style',
    },
    command = [[\mathscr]],
  },
  [ [[([a-zA-Z0-9])mcal]] ] = {
    context = {
      name = 'mathcal',
      dscr = 'Auto mathcal style',
    },
    command = [[\mathcal]],
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
  mbb = {
    context = {
      name = 'mathbb',
      dscr = 'mathbb style',
    },
    command = [[\mathbb]],
  },
  mscr = {
    context = {
      name = 'mathscr',
      dscr = 'mathscr style',
    },
    command = [[\mathscr]],
  },
  mcal = {
    context = {
      name = 'mathcal',
      dscr = 'mathcal style',
    },
    command = [[\mathcal]],
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

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_fonts_auto' })
ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_math_fonts' })
