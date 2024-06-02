---@diagnostic disable: undefined-global
local in_document = utils.tex.conditions.in_document

-- TODO: Expand only if the "mk"/"dm" is not part of a word. That is if there is a space in-front of it. If not, the
-- snippet type shouldn't be an `autosnippet`. <17-01-24>
-- TODO: Auto space if not "," or "." after the environment <17-01-24>
s(
  {
    trig = 'mk',
    name = 'inline math',
    condition = in_document,
    snippetType = 'autosnippet',
    dscr = 'add inline math delimiters',
    docstring = { [[\({1}\)]], [[${1}$]] },
  },
  c(1, {
    fmta([[\(<>\)]], r(1, 'inline_math', i(1))),
    -- fmta([[\(<>\)<>]], r(1, 'inline_math', i(1)), m(1, [[.*%\%)%p]], '', ' ')),
    fmta([[$<>$]], r(1, 'inline_math')),
    -- fmta([[$<>$<>]], r(1, 'inline_math'), m(1, [[.*%\%)%p ]], '', ' ')),
  })
)
s(
  {
    trig = 'dm',
    name = 'displayed math',
    condition = in_document,
    snippetType = 'autosnippet',
    dscr = 'add displayed math delimiters',
    docstring = [[ \[{1}\] ]],
  },
  fmta(
    [[\[
    <>
\] ]],
    i(1)
  )
)
