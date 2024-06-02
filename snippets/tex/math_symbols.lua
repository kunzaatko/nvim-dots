-- TODO: Inspiration from the Vimtex insertmode mappings <20-05-23>
---@diagnostic disable: undefined-global
local in_mathzone = utils.tex.conditions.in_mathzone
local in_alignment = utils.tex.conditions.in_alignment
local symbol_snippet = utils.tex.snippet_templates.symbol_snippet

-- TODO: Do not use list for this but a table with named values like in math_commands --
local greek_specs = {
  aaa = { context = { name = 'α' }, command = [[\alpha]] },
  bbb = { context = { name = 'β' }, command = [[\beta]] },
  www = { context = { name = 'ω' }, command = [[\omega]] },
  WWW = { context = { name = 'Ω' }, command = [[\Omega]] },
  ddd = { context = { name = 'δ' }, command = [[\delta]] },
  DDD = { context = { name = 'Δ' }, command = [[\Delta]] },
  vphi = { context = { name = 'φ' }, command = [[\varphi]] },
  eee = { context = { name = 'ε' }, command = [[\varepsilon]] },
}

for k, v in pairs(greek_specs) do
  symbol_snippet(vim.tbl_deep_extend('keep', { trig = k, condition = in_mathzone }, v.context), v.command)
end

local symbol_specs = {
  [':='] = { context = { name = '≔' }, command = [[\coloneqq]] },
  ['=:'] = { context = { name = '≕' }, command = [[\eqqcolon]] },
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
  nabb = { context = { name = '∇' }, command = [[\nabla]] },
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

for k, v in pairs(symbol_specs) do
  symbol_snippet(vim.tbl_deep_extend('keep', { trig = k, condition = in_mathzone }, v.context), v.command)
end

-- TODO: Make the first choice be `\cdots` when in matrix <21-03-22>
-- TODO: Place the cursor after the choice <kunzaatko>
s({
  trig = '...',
  name = 'dots',
  condition = in_mathzone,
  snippetType = 'autosnippet',
  dscr = 'Choice of dot commands',
  docstring = [[\ldots|\cdots|\vdots|\ddots]],
}, c(1, { t [[\ldots]], t [[\cdots]], t [[\vdots]], t [[\ddots]] }))

-- TODO: Make the choice with a restore node to maintain the input <21-03-22>
-- TODO: When in numbered environment, add a toggle to append `\nonumber` conditionally <21-03-22>
s({
  trig = '==',
  name = 'Equals',
  condition = in_alignment,
  snippetType = 'autosnippet',
  dscr = 'Auto equals in alignment',
  docstring = [[&= {1} \\]],
}, c(1, { fmta([[&= <> \\]], r(1, 'equation', i(1))), fmta([[&= <> \\ \nonumber]], r(1, 'equation')) }))

symbol_snippet({ trig = 'oo', name = '∘', snippetType = 'snippet', condition = in_mathzone }, [[\circ]])
