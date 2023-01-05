local M = {
  autosnippets = {},
  snippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node

local fmta = require('luasnip.extras.fmt').fmta

local in_mathzone = require('snippets.tex.utils').conditions.in_mathzone
local in_alignment = require('snippets.tex.utils').conditions.in_alignment

local symbol_snippet = require('snippets.tex.utils').snippet_templates.symbol_snippet

-- TODO: Do not use list for this but a table with named values like in math_commands --
local greek_specs = { --{{{
  aaa = { context = { name = 'α' }, command = [[\alpha]] },
  bbb = { context = { name = 'β' }, command = [[\beta]] },
  www = { context = { name = 'ω' }, command = [[\omega]] },
  WWW = { context = { name = 'Ω' }, command = [[\Omega]] },
  ddd = { context = { name = 'δ' }, command = [[\delta]] },
  DDD = { context = { name = 'Δ' }, command = [[\Delta]] },
  vphi = { context = { name = 'φ' }, command = [[\varphi]] },
  eee = { context = { name = 'ε' }, command = [[\varepsilon]] },
}

-- TODO: Add automath delimiters <29-09-22>
local greek_snippets = {}
for k, v in pairs(greek_specs) do
  table.insert(
    greek_snippets,
    symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_mathzone })
  )
end
vim.list_extend(M.autosnippets, greek_snippets) --}}}

local symbol_specs = { --{{{
  [':='] = { context = { name = '≔' }, command = [[\coloneqq]] },
  lll = { context = { name = 'ℓ' }, command = [[\ell]] },
  ['<|'] = { context = { name = '△' }, command = [[\triangle]] },
  ['||'] = { context = { name = '∣' }, command = [[\mid]] },
  cc = { context = { name = '⊂' }, command = [[\subset]] },
  notin = { context = { name = '∉' }, command = [[\not\in]] },
  inn = { context = { name = '∈' }, command = [[\in]] },
  ['RR'] = { context = { name = 'ℝ' }, command = [[\R]] },
  ['CC'] = { context = { name = 'ℂ' }, command = [[\C]] },
  ['QQ'] = { context = { name = 'ℚ' }, command = [[\Q]] },
  ['ZZ'] = { context = { name = 'ℤ' }, command = [[\Z]] },
  ['NN'] = { context = { name = 'N' }, command = [[\N]] },
  ['Nn'] = { context = { name = '∩' }, command = [[\cap]] },
  ['UU'] = { context = { name = '∪' }, command = [[\cup]] },
  ['OO'] = { context = { name = '∅' }, command = [[\emptyset]] },
  ['<>'] = { context = { name = '⇔' }, command = [[\Leftrightarrow]] },
  ['->'] = { context = { name = '→' }, command = [[\to]] },
  ['<->'] = { context = { name = '↔' }, command = [[\leftrightarrow]] },
  ['!>'] = { context = { name = '↦' }, command = [[\mapsto]] },
  [ [[\\\]] ] = { context = { name = '⧵' }, command = [[\setminus]] },
  ['>>'] = { context = { name = '≫' }, command = [[\gg]] },
  ['<<'] = { context = { name = '≪' }, command = [[\ll]] },
  ['~~'] = { context = { name = '~' }, command = [[\sim]] },
  xx = { context = { name = '×' }, command = [[\times]] },
  nabl = { context = { name = '∇' }, command = [[\nabla]] },
  ['**'] = { context = { name = '·' }, command = [[\cdot]] },
  iff = { context = { name = '⟺' }, command = [[\iff]] },
  ['!='] = { context = { name = '≠' }, command = [[\neq]] },
  ['<!'] = { context = { name = '◁' }, command = [[\triangleleft]] },
  ooo = { context = { name = '∞' }, command = [[\infty]] },
  ['<='] = { context = { name = '≤' }, command = [[\le]] },
  ['>='] = { context = { name = '≥' }, command = [[\ge]] },
  land = { context = { name = '∧' }, command = [[\land]] },
  ['EE'] = { context = { name = '∃' }, command = [[\exists]] },
  ['AA'] = { context = { name = '∀' }, command = [[\forall]] },
  ['=>'] = { context = { name = '⟹' }, command = [[\implies]] },
}

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
  table.insert(
    symbol_snippets,
    symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_mathzone })
  )
end
vim.list_extend(M.autosnippets, symbol_snippets) --}}}

-- TODO: Make the first choice be `\cdots` when in matrix <21-03-22>
-- TODO: Place the cursor after the choice <kunzaatko>
table.insert(
  M.autosnippets,
  s(
    { trig = '...', name = 'dots', dscr = 'Choice of dot commands', docstring = [[\ldots|\cdots|\vdots|\ddots]] },
    c(1, { t [[\ldots]], t [[\cdots]], t [[\vdots]], t [[\ddots]] }),
    { condition = in_mathzone }
  )
)

-- TODO: Make the choice with a restore node to maintain the input <21-03-22>
-- TODO: When in numbered environment, add a toggle to append `\nonumber` conditionally <21-03-22>
table.insert(
  M.autosnippets,
  s(
    { trig = '==', name = 'Equals', dscr = 'Auto equals in alignment', docstring = [[&= {1} \\]] },
    c(1, { fmta([[&= <> \\]], r(1, 'equation', i(1))), fmta([[&= <> \\ \nonumber]], r(1, 'equation')) }),
    { condition = in_alignment }
  )
)

table.insert(M.snippets, symbol_snippet({ trig = 'oo', name = '∘' }, [[\circ]], { condition = in_mathzone }))

ls.add_snippets('tex', M.autosnippets, { type = 'autosnippets', key = 'latex_math_symbols_auto' })
ls.add_snippets('tex', M.snippets, { type = 'snippets', key = 'latex_math_symbols' })
