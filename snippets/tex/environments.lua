---@diagnostic disable: undefined-global
local in_document = utils.tex.conditions.in_document
local in_mathzone = utils.tex.conditions.in_mathzone
local in_normalzone = utils.tex.conditions.in_normalzone
local simple_env_nodes = utils.tex.snippet_templates.simple_env_nodes
local named_env_nodes = utils.tex.snippet_templates.named_env_nodes

-- TODO: Visual surround environments <26-06-24>

s( -- \begin{}[] \end{}
  {
    trig = 'beg',
    name = 'begin',
    condition = in_document * conds.line_begin,
    snippetType = 'autosnippet',
    dscr = 'Begin environment',
    docstring = [[
\begin{{1:environment}}[{2}]
  {3}
\end{{1}}{0}
]],
  },
  fmta(
    [[
    \begin{<>}<>
      <>
    \end{<>}<>
    ]],
    {
      i(1), -- environment name
      sn(2, { m(1, [[.+]], '[', ''), i(1), m(1, [[.+]], ']', '') }), -- optional arguments to environment
      i(3),
      rep(1),
      i(0),
    }
  )
)

s( -- \begin{}[] \end{}
  {
    trig = 'beg',
    name = 'begin',
    condition = in_document,
    snippetType = 'snippet',
    dscr = 'Begin environment',
    docstring = [[
\begin{{1:environment}}[{2}]
  {3}
\end{{1}}{0}
]],
  },
  fmta(
    [[
    \begin{<>}<>
      <>
    \end{<>}<>
    ]],
    {
      i(1), -- environment name
      sn(2, { m(1, [[.+]], '[', ''), i(1), m(1, [[.+]], ']', '') }), -- optional arguments to environment
      i(3),
      rep(1),
      i(0),
    }
  )
)

s({
  trig = 'def',
  name = 'Definition',
  condition = in_normalzone * conds.line_begin,
  -- snippetType = 'autosnippet',
  dscr = 'Definition environment in normal zone',
  docstring = [[
  \begin{definition}[{1:name}]
    {2}
  \end{definition}{0}
  ]],
}, named_env_nodes 'definition')

s({
  trig = 'thm',
  name = 'Theorem',
  condition = in_normalzone * conds.line_begin,
  -- snippetType = 'autosnippet',
  dscr = 'Theorem environment in normal zone',
  docstring = [[
  \begin{theorem}[{1:name}]
    {2}
  \end{theorem}{0}
  ]],
}, named_env_nodes 'theorem')

s({
  trig = 'proof',
  name = 'Proof',
  condition = in_normalzone * conds.line_begin,
  -- snippetType = 'autosnippet',
  dscr = 'Proof environment in normal zone',
  docstring = [[
  \begin{proof}
    {1}
  \end{proof}{0}
  ]],
}, simple_env_nodes 'proof')

s({
  trig = 'cor',
  name = 'Corollary',
  condition = in_normalzone * conds.line_begin,
  -- snippetType = 'autosnippet',
  dscr = 'Corollary environment in normal zone',
  docstring = [[
  \begin{corollary}[{1:name}]
    {2}
  \end{corollary}{0}
  ]],
}, named_env_nodes 'corollary')

s({
  trig = 'lem',
  name = 'Lemma',
  condition = in_normalzone * conds.line_begin,
  -- snippetType = 'autosnippet',
  dscr = 'Lemma environment in normal zone',
  docstring = [[
  \begin{lemma}[{1:name}]
    {2}
  \end{lemma}{0}
  ]],
}, named_env_nodes 'lemma')

-- TODO: Add support for visual <21-03-22, kunzaatko>
local simple_env_snippet_node = function(envname, restore)
  return sn(1, simple_env_nodes(envname, restore))
end

s({
  trig = 'ali',
  name = 'Align',
  condition = in_mathzone,
  snippetType = 'autosnippet',
  dscr = 'Aligned math environment in math zone',
  docstring = [[
  \begin{aligned}
    {1}
  \end{aligned}{0}
  ]],
}, simple_env_nodes 'aligned')

s({
  trig = 'split',
  name = 'Split',
  condition = in_mathzone,
  snippetType = 'autosnippet',
  dscr = 'Split environment in math zone',
  docstring = [[
  \begin{split}
    {1}
  \end{split}{0}
  ]],
}, simple_env_nodes 'split')

s(
  {
    trig = 'ali',
    name = 'Align',
    condition = in_document * conds.line_begin,
    snippetType = 'autosnippet',
    dscr = 'Align math environment choice',
    docstring = [[
  \begin{align|flalign|flalign*}
    {1}
  \end{align|flalign|flatign*}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('align', 'math-align'),
    simple_env_snippet_node('flalign', 'math-align'),
    simple_env_snippet_node('flalign*', 'math-align'),
  })
)

s(
  {
    trig = 'eqn',
    name = 'Equation',
    condition = in_document * conds.line_begin,
    snippetType = 'autosnippet',
    dscr = 'Equation math environment',
    docstring = [[
  \begin{equation(*)}
    {1}
  \end{equation(*)}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('equation', 'math-equation-auto'),
    simple_env_snippet_node('equation*', 'math-equation-auto'),
  })
)

-- NOTE: If not at the beginning of the line, it requires confirmation
-- TODO: Make a helper function to generate autosnippet under additional condition and normal snippet otherwise <25-06-24>
s(
  {
    trig = 'eqn',
    name = 'Equation',
    condition = in_document,
    snippetType = 'snippet',
    dscr = 'Equation math environment',
    docstring = [[
  \begin{equation(*)}
    {1}
  \end{equation(*)}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('equation', 'math-equation'),
    simple_env_snippet_node('equation*', 'math-equation'),
  })
)

s(
  {
    trig = 'gat',
    name = 'Gather',
    condition = in_document * conds.line_begin,
    snippetType = 'autosnippet',
    dscr = 'Gather math environment',
    docstring = [[
  \begin{gather(*)}
    {1}
  \end{gather(*)}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('gather', 'math-gather-auto'),
    simple_env_snippet_node('gather*', 'math-gather-auto'),
  })
)

s(
  {
    trig = 'gat',
    name = 'Gather',
    condition = in_document,
    snippetType = 'snippet',
    dscr = 'Gather math environment',
    docstring = [[
  \begin{gather(*)}
    {1}
  \end{gather(*)}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('gather', 'math-gather'),
    simple_env_snippet_node('gather*', 'math-gather'),
  })
)

s({
  trig = 'gat',
  name = 'Gather',
  condition = in_mathzone * conds.line_begin,
  snippetType = 'autosnippet',
  dscr = 'Gather math environment',
  docstring = [[
  \begin{gathered}
    {1}
  \end{gathered}{0}
  ]],
}, simple_env_nodes 'gathered')

s({
  trig = 'gat',
  name = 'Gather',
  condition = in_mathzone,
  snippetType = 'snippet',
  dscr = 'Gather math environment',
  docstring = [[
  \begin{gathered}
    {1}
  \end{gathered}{0}
  ]],
}, simple_env_nodes 'gathered')

-- TODO: Auto line alignments <25-06-24>
s(
  {
    trig = 'mat',
    name = 'Matrix',
    condition = in_mathzone * conds.line_begin,
    snippetType = 'autosnippet',
    dscr = 'Aligned math environment in math zone',
    docstring = [[
  \begin{pmatrix|matrix|bmatrix|vmatrix|Bmatrix|Vmatrix}
    {1}
  \end{pmatrix|matrix|bmatrix|vmatrix|Bmatrix|Vmatrix}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('pmatrix', 'math-matrix-auto'),
    simple_env_snippet_node('matrix', 'math-matrix-auto'),
    simple_env_snippet_node('bmatrix', 'math-matrix-auto'),
    simple_env_snippet_node('vmatrix', 'math-matrix-auto'),
    simple_env_snippet_node('Bmatrix', 'math-matrix-auto'),
    simple_env_snippet_node('Vmatrix', 'math-matrix-auto'),
  })
)

s(
  {
    trig = 'mat',
    name = 'Matrix',
    condition = in_mathzone,
    snippetType = 'snippet',
    dscr = 'Aligned math environment in math zone',
    docstring = [[
  \begin{pmatrix|matrix|bmatrix|vmatrix|Bmatrix|Vmatrix}
    {1}
  \end{pmatrix|matrix|bmatrix|vmatrix|Bmatrix|Vmatrix}{0}
  ]],
  },
  c(1, {
    simple_env_snippet_node('pmatrix', 'math-matrix'),
    simple_env_snippet_node('matrix', 'math-matrix'),
    simple_env_snippet_node('bmatrix', 'math-matrix'),
    simple_env_snippet_node('vmatrix', 'math-matrix'),
    simple_env_snippet_node('Bmatrix', 'math-matrix'),
    simple_env_snippet_node('Vmatrix', 'math-matrix'),
  })
)

s({
  trig = 'proof',
  name = 'Proof',
  condition = in_document * conds.line_begin,
  snippetType = 'autosnippet',
  dscr = 'Proof environment',
  docstring = [[
  \begin{proof}
    {1}
  \end{proof}{0}
  ]],
}, simple_env_nodes 'proof')

s({
  trig = 'proof',
  name = 'Proof',
  condition = in_document,
  snippetType = 'snippet',
  dscr = 'Proof environment',
  docstring = [[
  \begin{proof}
    {1}
  \end{proof}{0}
  ]],
}, simple_env_nodes 'proof')

s({
  trig = 'item',
  name = 'Itemize',
  condition = in_document * conds.line_begin,
  snippetType = 'autosnippet',
  dscr = 'Itemize environment',
  docstring = [[
  \begin{itemize}
    {1}
  \end{itemize}{0}
  ]],
}, simple_env_nodes 'itemize')

s({
  trig = 'item',
  name = 'Itemize',
  condition = in_document,
  snippetType = 'snippet',
  dscr = 'Itemize environment',
  docstring = [[
  \begin{itemize}
    {1}
  \end{itemize}{0}
  ]],
}, simple_env_nodes 'itemize')
