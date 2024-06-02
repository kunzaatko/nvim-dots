---@diagnostic disable: undefined-global
local in_preable = utils.tex.conditions.in_preable

s(
  {
    trig = 'template',
    dscr = 'Template article preamble with basic packages',
    condition = in_preable,
    docstring = string.format(
      [[
\documentclass[{2:arguments}]{{1:class}}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage[czech]{babel}
\usepackage{amsmath, amssymb}

\usepackage{hyperref}
\usepackage{import}
\usepackage{xifthen}
\pdfminorversion=7
\usepackage{pdfpages}
\usepackage{transparent}
\newcommand{\incfig}[1]{
\def\svgwidth{\columnwidth}
\import{./figures/}{#1.pdf_tex}
}

\pdfsuppresswarningpagegroup=1

\title{{3}}
\author{%s}

\begin{document}
  {0}
\end{document}
]],
      _G.luasnip.vars.real_name
    ),
  },
  fmta(
    [[
      \documentclass[<>]{<>}

      \usepackage[utf8]{inputenc}
      \usepackage[T1]{fontenc}
      \usepackage{textcomp}
      \usepackage[czech]{babel}
      \usepackage{amsmath, amssymb}

      % figure support
      \usepackage{import}
      \usepackage{xifthen}
      \pdfminorversion=7
      \usepackage{pdfpages}
      \usepackage{transparent}
      \newcommand{\incfig}[1]{%
        \def\svgwidth{\columnwidth}
        \import{./figures/}{#1.pdf_tex}
      }

      \pdfsuppresswarningpagegroup=1

      \title{<>}
      \author{<>}

      \begin{document}
        <>
      \end{document}
      ]],
    {
      i(2, 'a4paper'),
      i(1, 'article'),
      i(3),
      f(function()
        return _G.luasnip.vars.real_name
      end),
      i(0),
    }
  )
)

s(
  { trig = 'pac', dscr = 'Package command', docstring = [[\usepackage[{2}]{{1}}0]], condition = in_preamble },
  fmta([[\usepackage<>{<>}]], { sn(2, { m(1, [[.+]], '[', ''), i(1), m(1, [[.+]], ']', '') }), i(1) }),
  {}
)
