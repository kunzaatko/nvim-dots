---@diagnostic disable: undefined-global

local in_normalzone = utils.tex.conditions.in_normalzone

s({
  trig = '__',
  name = 'emphasize',
  condition = in_normalzone,
  snippetType = 'autosnippet',
  dscr = 'Emphasize an argument',
  docstring = [[\emph{{1}}{0}]],
  wordTrig = true,
}, fmta([[\emph{<>} ]], i(1)))

local simple_command_snippet = utils.tex.snippet_templates.simple_command_snippet

simple_command_snippet({ trig = 'lbl', dscr = 'Add label', condition = in_normalzone }, '\\label')

local auto_backslash_argument_command_snippet = utils.tex.snippet_templates.auto_backslash_argument_command_snippet

local auto_backslash_specs = {
  'ref',
  'include',
}
for _, v in ipairs(auto_backslash_specs) do
  auto_backslash_argument_command_snippet { trig = v, snippetType = 'snippet', condition = in_normalzone }
end
