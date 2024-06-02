---@diagnostic disable: undefined-global

local in_mathzone = utils.tex.conditions.in_mathzone
local delimiter_snippet = utils.tex.snippet_templates.delimiter_snippet

local delimiter_specs_auto = {
  ceil = { context = { name = 'ceil' }, delimiters = { [[\left\lceil]], [[\right\rceil]] } },
  floor = { context = { name = 'floor' }, delimiters = { [[\left\lfloor]], [[\right\rfloor]] } },
  [ [[()]] ] = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
}

for k, v in pairs(delimiter_specs_auto) do
  delimiter_snippet(
    vim.tbl_deep_extend('error', { trig = k, snippetType = 'autosnippet', condition = in_mathzone }, v.context),
    v.delimiters
  )
end

local delimiter_specs = {
  lr = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
  [ [[lr(]] ] = { context = { name = 'parethesis' }, delimiters = { [[\left(]], [[\right)]] } },
  [ [[lr|]] ] = { context = { name = 'bar' }, delimiters = { [[\left|]], [[\right|]] } },
  [ [[lr[]] ] = { context = { name = 'bracket' }, delimiters = { [[\left[]], '\\right]' } },
  lra = { context = { name = 'angle' }, delimiters = { [[\left<]], [[\right>]] } },
  lrb = { context = { name = 'brace' }, delimiters = { [[\left\{]], [[\right\}]] } },
}

for k, v in pairs(delimiter_specs) do
  delimiter_snippet(vim.tbl_deep_extend('error', { trig = k, condition = in_mathzone }, v.context), v.delimiters)
end

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
