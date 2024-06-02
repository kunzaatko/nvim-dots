---@diagnostic disable: undefined-global

local in_document = utils.tex.conditions.in_document

-- TODO: conditionally remove thebrackets <18-06-23>
s(
  {
    trig = 'fl',
    dscr = 'flashcard',
    condition = in_document,
    docstring = [[\begin{flashcard}[{2:Definice}]{{1:name}}
  $3
\end{flashcard}$0
  ]],
  },
  fmta(
    [[
  \begin{flashcard}[<>]{<>}
  <>
  \end{flashcard}
  ]],
    {
      i(2, 'type'),
      i(1, 'name'),
      i(3),
    }
  ),
  {}
)

s(
  {
    trig = 'flt',
    dscr = 'flashcard',
    condition = in_document,
    docstring = [[\begin{flashcard}[Věta]{{1:name}}
  $3
\end{flashcard}$0
  ]],
  },
  fmta(
    [[
  \begin{flashcard}[Věta]{<>}
  <>
  \end{flashcard}
  ]],
    {
      i(1, 'name'),
      i(2),
    }
  ),
  {}
)
