---@diagnostic disable: undefined-global
local after_math_variable = utils.tex.conditions.after_math_variable
local in_mathzone = utils.tex.conditions.in_mathzone

s({
  trig = 'invs',
  name = 'inverse',
  condition = after_math_variable,
  snippetType = 'autosnippet',
  dscr = 'Add inverse exponent',
  docstring = '^{-1}{0}',
  wordTrig = false,
}, { t [[^{-1}]] })
-- TODO: Should be a different symbol probably <20-03-22>
s({
  trig = 'compl',
  name = 'complement',
  condition = after_math_variable,
  snippetType = 'autosnippet',
  dscr = 'Add complement exponent',
  docstring = '^{c}{0}',
  wordTrig = false,
}, { t [[^{c}]] })
s(
  -- FIX: Does not expand, but the condition computes to true... Where is the problem? <20-04-23>
  {--[[ TODO:  Check that I use this only in these situations ]]
    trig = '([%w}])__', -- regTrig assures that it is after a math variable
    name = 'manual subscript',
    -- condition = in_mathzone,
    snippetType = 'autosnippet',
    dscr = 'Subscript',
    docstring = [[_{{1}}{0}]],
    wordTrig = false,
    regTrig = true,
  },
  fmta([[<>_{<>}]], { f(function(_, snip)
    return snip.captures[1]
  end), i(1) })
)
s(
  {
    trig = '([%a])(%d)',
    name = 'auto-subscript',
    condition = in_mathzone,
    dscr = 'Automatically add a subscript',
    snippetType = 'autosnippet',
    docstring = [[{capture:[a-zA-Z]}_{capture(%d)}]],
    regTrig = true,
    wordTrig = false,
  },
  f(function(_, snip)
    return snip.captures[1] .. '_' .. snip.captures[2]
  end)
)
s(
  {
    trig = '([%a])_(%d%d+)',
    name = 'auto-subscript',
    condition = in_mathzone,
    dscr = 'Automatically add a subscript',
    snippetType = 'autosnippet',
    docstring = [[{capture:[a-zA-Z]}_{{capture(%d)}}]],
    regTrig = true,
    wordTrig = false,
  },
  f(function(_, snip)
    return snip.captures[1] .. '_{' .. snip.captures[2] .. '}'
  end)
)
-- FIX: This should be a better trigger. There is a conflict with `inn` -> ∈ snippet. This should only expand, if not
-- "inn" <19-01-24>
s(
  {
    trig = '([x,y,T,a,b])nn',
    name = 'auto-n-subscript',
    condition = in_mathzone,
    dscr = 'Automatically add `n` subscript',
    snippetType = 'autosnippet',
    docstring = [[{capture:[a-zA-Z]}_{{capture(%d)}}]],
    regTrig = true,
    wordTrig = false,
  },
  f(function(_, snip)
    return snip.captures[1] .. '_{n}'
  end)
)
s(
  {
    trig = '([%w])sr',
    name = '^2',
    condition = in_mathzone,
    snippetType = 'autosnippet',
    docstring = '^2{0}',
    dscr = 'variable squared',
    wordTrig = false,
    regTrig = true,
  },
  f(function(_, snip)
    return snip.captures[1] .. '^2'
  end)
)
s(
  {
    trig = '([%w])cb',
    name = '^3',
    condition = in_mathzone,
    snippetType = 'autosnippet',
    docstring = '^3{0}',
    dscr = 'variable cubed',
    wordTrig = false,
    regTrig = true,
  },
  f(function(_, snip)
    return snip.captures[1] .. '^3'
  end)
)
-- TODO: Specify the regex such that the expansions does not collide with other commands <19-01-24>
s(
  {
    trig = '([%w|%p])td',
    name = 'to the power',
    condition = in_mathzone,
    snippetType = 'autosnippet',
    docstring = '^{1}{0}',
    dscr = 'variable to the power of',
    wordTrig = false,
    regTrig = true,
  },
  fmta([[<>^{<>}]], { f(function(_, snip)
    return snip.captures[1]
  end), i(1) })
)

s({
  trig = 'ser',
  name = 'series',
  condition = in_mathzone,
  docstring = '\\sum_{n = 1}^{\\infty} {}',
  dscr = 'variable to the power of',
  wordTrig = false,
  regTrig = true,
}, fmta([[\sum_{n = 1}^{\infty} <>]], { i(1, 'a_n') }))

local auto_backslash_snippet = utils.tex.snippet_templates.auto_backslash_snippet

local auto_backslash_specs = {
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

for _, v in ipairs(auto_backslash_specs) do
  auto_backslash_snippet { trig = v, condition = in_mathzone }
end
