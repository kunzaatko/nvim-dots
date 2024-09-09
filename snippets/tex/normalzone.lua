---@diagnostic disable: undefined-global
local in_normalzone = utils.tex.conditions.in_normalzone
local simple_command_snippet = utils.tex.snippet_templates.simple_command_snippet

simple_command_snippet({
  trig = '__',
  name = 'emphasize',
  condition = in_normalzone,
  snippetType = 'autosnippet',
  dscr = 'Emphasize an argument',
  docstring = [[\emph{{1}}{0}]],
  wordTrig = true,
}, [[\emph]], {}, { visual = true })

simple_command_snippet({ trig = 'lbl', dscr = 'Add label', condition = in_normalzone }, '\\label', {}, {})

local font_snippet_specs = {
  ['tbf'] = { command = [[\textbf]] },
  ['ttt'] = { command = [[\texttt]] },
  ['tit'] = { command = [[\textit]] },
  ['tsl'] = { command = [[\textsl]] },
  ['tsc'] = { command = [[\textsc]] },
  ['trm'] = { command = [[\textrm]] },
  ['tsf'] = { command = [[\textsf]] },
}

for k, v in pairs(font_snippet_specs) do
  simple_command_snippet(
    { trig = k, dscr = 'Font command ' .. v.command, condition = in_normalzone, snippetType = 'snippet' },
    v.command,
    {},
    {}
  )
end

local auto_backslash_argument_command_snippet = utils.tex.snippet_templates.auto_backslash_argument_command_snippet

local auto_backslash_specs = {
  'ref',
  'include',
  'tiny',
  'scriptsize',
  'footnotesize',
  'small',
  'normalsize',
  'large',
  'Large',
  'LARGE',
  'huge',
  'Huge',
}
for _, v in ipairs(auto_backslash_specs) do
  auto_backslash_argument_command_snippet { trig = v, snippetType = 'snippet', condition = in_normalzone }
end
