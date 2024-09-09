---@diagnostic disable: undefined-global
local in_normalzone = utils.tex.conditions.in_normalzone
local in_list = utils.tex.conditions.in_list

s({ trig = 'desc', name = 'Description', condition = in_normalzone * conds.line_begin }, {
  t { '\\begin{description}', '\t\\item[' },
  i(1),
  t { ']' },
  i(2),
  t { '', '\\end{description}' },
  i(0),
})

s(
  {
    trig = 'enum',
    name = 'enumerate environment',
    condition = in_normalzone * conds.line_begin,
    -- snippetType = 'autosnippet',
    dscr = 'Enumerate environment with options for the label',
    docstring = [[
    \begin{enumerate}[{1:label choice}]
      \item {2}
    \end{enumerate}
    ]],
  },
  fmta(
    [[
    \begin{enumerate}<>
      \item <>
    \end{enumerate}
    ]],
    {
      sn(1, {
        m(1, [[.+]], '[', ''),
        c(1, {
          t [[]],
          fmta([[<>label = <>]], { i(1), c(2, { t [[\alph*)]], t [[(\alph*)]], t [[\alph*.]] }) }),
          fmta([[<>label = <>]], { i(1), c(2, { t [[\roman*.]], t [[(\roman*)]], t [[\roman*)]] }) }),
          fmta([[<>label = <>]], { i(1), c(2, { t [[\Roman*.]], t [[\Roman*)]], t [[(\Roman*)]] }) }),
        }),
        m(1, [[.+]], ']', ''),
      }), -- optional arguments to environment
      i(2),
    }
  )
)

-- TODO: Can be redefined in enum/description to include label
s(
  {
    trig = [[^(%s*)-]],
    name = 'item',
    condition = in_list,
    snippetType = 'autosnippet',
    regTrig = true,
    dscr = 'item in list environment',
    docstring = [[\item {0}]],
  },
  f(function(_, snip)
    return snip.captures[1] .. [[\item]]
  end)
)
