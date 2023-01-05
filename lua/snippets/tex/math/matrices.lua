---@diagnostic disable: unused-local
local M = {
  autosnippets = {},
  snippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node

local fmta = require('luasnip.extras.fmt').fmta

local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone

-- TODO: Universal matrix snippet <21-03-22>

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_matrices_auto' })
ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_math_matrices' })

--[[ snippet pmat "pmat" iA
\begin{pmatrix} $1 \end{pmatrix} $0
endsnippet

snippet bmat "bmat" iA
\begin{bmatrix} $1 \end{bmatrix} $0
endsnippet ]]
