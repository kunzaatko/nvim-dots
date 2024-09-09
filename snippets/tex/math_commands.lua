---@diagnostic disable: undefined-global
local in_mathzone = utils.tex.conditions.in_mathzone
local capture_wrap_snippet = utils.tex.snippet_templates.capture_wrap_snippet

local auto_capture_specs = {
  [ [[([a-zA-Z])hat]] ] = {
    context = {
      name = 'hat',
      dscr = 'automatic hat command',
    },
    command = [[\hat]],
  },
  [ [[([a-zA-Z])tld]] ] = {
    context = {
      name = 'tilde',
      dscr = 'automatic tilde command',
    },
    command = [[\tilde]],
  },
  [ [[([a-zA-Z])vec]] ] = {
    context = {
      name = 'vec',
      dscr = 'automatic vec command',
    },
    command = [[\vec]],
  },
  [ [[([a-zA-Z])bar]] ] = {
    context = {
      name = 'bar',
      dscr = 'automatic overline command',
    },
    command = [[\bar]],
  },
}

for k, v in pairs(auto_capture_specs) do
  capture_wrap_snippet(vim.tbl_deep_extend('keep', { trig = k, condition = in_mathzone }, v.context or {}), v.command)
end

local simple_command_snippet = utils.tex.snippet_templates.simple_command_snippet

local simple_command_specs = {
  hat = {
    context = {
      name = 'hat',
      dscr = 'hat command',
    },
    command = [[\hat]],
  },
  tld = {
    context = {
      name = 'tilde',
      dscr = 'tilde command',
    },
    command = [[\tilde]],
  },
  vec = {
    context = {
      name = 'vec',
      dscr = 'vec command',
    },
    command = [[\vec]],
  },
  bar = {
    context = {
      name = 'bar',
      dscr = 'bar command',
    },
    command = [[\bar]],
  },
  tt = {
    context = {
      name = 'text',
      dscr = 'text field in math',
    },
    command = [[\text]],
  },
  sq = {
    context = {
      name = [[square root]],
      dscr = 'square root of argument',
    },
    command = [[\sqrt]],
  },
  under = {
    context = {
      name = [[underbrace]],
      dscr = 'underbraced expression',
      snippetType = 'snippet',
    },
    command = [[\underbrace]],
  },
  over = {
    context = {
      name = [[overbrace]],
      dscr = 'overbraced expression',
      snippetType = 'snippet',
    },
    command = [[\overbrace]],
  },
}

for k, v in pairs(simple_command_specs) do
  simple_command_snippet(vim.tbl_deep_extend('keep', { trig = k, condition = in_mathzone }, v.context or {}), v.command)
end

local indexing_command_snippet = utils.tex.snippet_templates.indexing_command_snippet
local indexers = utils.tex.snippet_parts.indexers

s(
  {
    -- FIX:  This will not work for a numerator that includes a paren
    trig = [[%((.*)%)/]],
    name = 'fracion of ({capture})',
    docstring = [[\frac{{capture}}{{1}}{0}]],
    dscr = 'wrap expresion in () in a fraction command',
    regTrig = true,
    wordTrig = false,
    condition = in_mathzone,
  },
  fmta([[\frac{<>}{<>}]], { f(function(_, snip)
    return snip.captures[1]
  end), i(1) }),
  {}
)

-- TODO: add quad text snippet as in physics package
s({
  trig = 'qq',
  name = 'quad space',
  dscr = 'quad space command',
  condition = in_mathzone,
}, t [[\quad]], {})

local indexing_command_specs = { --{{{
  sum = {
    command = [[\sum]],
    indexes = { indexers.discrete_bound, indexers.discrete_set },
  },
  prod = {
    command = [[\prod]],
    indexes = { indexers.discrete_bound, indexers.discrete_set },
  },
  int = {
    -- TODO: Add tail to command that will be determined by the indexing
    command = [[\int]],
    indexes = { indexers.continuous_bound, indexers.continuous_set },
  },
  nnn = {
    command = [[\bigcap]],
    indexes = { indexers.discrete_set, indexers.continuous_set, indexers.discrete_bound },
    auto = true,
  },
  uuu = {
    command = [[\bigcup]],
    indexes = { indexers.discrete_set, indexers.continuous_set, indexers.discrete_bound },
    auto = true,
  },
  -- lim
  -- limsup
  -- taylor
}

for k, v in pairs(indexing_command_specs) do
  indexing_command_snippet(
    vim.tbl_extend(
      'keep',
      { trig = k, snippetType = v.auto and 'autosnippet' or 'snippet', condition = in_mathzone },
      v.context or {}
    ),
    v.command,
    v.indexes
  )
end
