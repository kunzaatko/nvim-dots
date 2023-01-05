local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local l = require('luasnip.extras').lambda
local dl = require('luasnip.extras').dynamic_lambda

-- TODO: Add support for visual selection the title <18-03-22> --
-- TODO: Generate these using a function. They are prettymuch the same <17-03-22> --
local sections = {
  s(
    {
      trig = 'sec',
      name = 'Section',
      dscr = 'Section command with a label',
      docstring = [[
\section{{1:section title}}%
\label{sec:{2:section_label}}
]],
    },
    fmta(
      [[
      \section{<>}%
      \label{sec:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'sec*',
      name = 'Section',
      dscr = 'Unnumbered section command with a label',
      docstring = [[
\section*{{1:section title}}%
\label{sec:{2:section_label}}
]],
    },
    fmta(
      [[
      \section*{<>}%
      \label{sec:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'sub',
      name = 'Subsection',
      dscr = 'Subsection command with a label',
      docstring = [[
\subsection{{1:subsection title}}%
\label{sub:{2:subsection_label}}
]],
    },
    fmta(
      [[
      \subsection{<>}%
      \label{sub:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'sub*',
      name = 'Subsection',
      dscr = 'Unnumbered subsection command with a label',
      docstring = [[
\subsection*{{1:subsection title}}%
\label{sub:{2:subsection_label}}
]],
    },
    fmta(
      [[
      \subsection*{<>}%
      \label{sub:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'ssub',
      name = 'Subsubsection',
      dscr = 'Subsubsection command with a label',
      docstring = [[
\subsubsection{{1:subsubsection title}}%
\label{ssub:{2:subsubsection_label}}
]],
    },
    fmta(
      [[
      \subsubsection{<>}%
      \label{ssub:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'ssub*',
      name = 'Subsubsection',
      dscr = 'Unnumbered subsubsection command with a label',
      docstring = [[
\subsubsection*{{1:subsubsection title}}%
\label{ssub:{2:subsubsection_label}}
]],
    },
    fmta(
      [[
      \subsubsection*{<>}%
      \label{ssub:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
}

ls.add_snippets('tex', sections, { type = 'snippets', key = 'latex_sections' })

local paragraphs = {
  s(
    {
      trig = 'par',
      name = 'Paragraph',
      dscr = 'Paragraph command with a title and label',
      docstring = [[
\paragraph{{1:paragraph title}}%
\label{par:{2:paragraph_label}}
]],
    },
    fmta(
      [[
      \paragraph{<>}%
      \label{par:<>}
      <>
      ]],
      { i(1, 'Title'), dl(2, l._1:lower():gsub(' ', '_'), 1), i(0) }
    )
  ),
  s(
    {
      trig = 'spar',
      name = 'Subparagraph',
      dscr = 'Subparagraph command with a title and label',
      docstring = [[
\subparagraph{{1:subparagraph title}}%
\label{spar:{2:subparagraph_label}}
]],
    },
    fmta(
      [[
      \subparagraph{<>}%
      \label{spar:<>}
      ]],
      {
        i(1, 'Title'),
        dl(2, l._1:lower():gsub(' ', '_'), 1),
      }
    )
  ),
}

ls.add_snippets('tex', paragraphs, { type = 'snippets', key = 'latex_paragraphs' })
