---@diagnostic disable: unused-local
local M = {
  autosnippets = {},
  snippets = {},
}

local ls = require 'luasnip'

local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone

local delimiter_snippet = require('snippets.tex.utils').snippet_templates.delimiter_snippet

local delimiter_specs_auto = { --{{{
  ceil = { context = { name = 'ceil' }, delimiters = { [[\left\lceil]], [[\right\rceil]] } },
  floor = { context = { name = 'floor' }, delimiters = { [[\left\lfloor]], [[\right\rfloor]] } },
  [ [[()]] ] = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
}
local delimiter_snippets_auto = {}
for k, v in pairs(delimiter_specs_auto) do
  table.insert(
    delimiter_snippets_auto,
    delimiter_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.delimiters, { condition = in_mathzone })
  )
end
vim.list_extend(M.autosnippets, delimiter_snippets_auto) --}}}

local delimiter_specs = { --{{{
  lr = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
  [ [[lr(]] ] = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
  [ [[lr|]] ] = { context = { name = 'bar' }, delimiters = { [[\left|]], [[\right|]] } },
  [ [[lr[]] ] = { context = { name = 'bracket' }, delimiters = { [[\left[]], '\\right]' } },
  lra = { context = { name = 'angle' }, delimiters = { [[\left<]], [[\right>]] } },
  lrb = { context = { name = 'brace' }, delimiters = { [[\left\{]], [[\right\}]] } },
}
local delimiter_snippets = {}
for k, v in pairs(delimiter_specs) do
  table.insert(
    delimiter_snippets,
    delimiter_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.delimiters, { condition = in_mathzone })
  )
end
vim.list_extend(M.snippets, delimiter_snippets) --}}}

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_delimiters_auto' })
ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_math_delimiters' })
--[[
context "math()"
snippet ceil "ceil" iA
\left\lceil $1 \right\rceil $0
endsnippet

context "math()"
snippet floor "floor" iA
\left\lfloor $1 \right\rfloor$0
endsnippet

context "math()"
snippet () "left( right)" iA
\left( ${1:${VISUAL}} \right) $0
endsnippet

snippet lr "left( right)" i
\left( ${1:${VISUAL}} \right) $0
endsnippet

snippet lr) "left( right)" i
\left( ${1:${VISUAL}} \right) $0
endsnippet

snippet lr| "left| right|" i
\left| ${1:${VISUAL}} \right| $0
endsnippet

snippet lr{ "left\{ right\}" i
\left\\{ ${1:${VISUAL}} \right\\} $0
endsnippet

snippet lrb "left\{ right\}" i
\left\\{ ${1:${VISUAL}} \right\\} $0
endsnippet

snippet lr[ "left[ right]" i
\left[ ${1:${VISUAL}} \right] $0
endsnippet

snippet lra "leftangle rightangle" iA
\left<${1:${VISUAL}} \right>$0
endsnippet ]]
