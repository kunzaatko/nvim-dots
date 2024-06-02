---@diagnostic disable: undefined-global

local in_mathzone = utils.tex.conditions.in_mathzone
local capture_wrap_snippet = utils.tex.snippet_templates.capture_wrap_snippet

local auto_capture_specs = {
  [ [[([a-zA-Z0-9])mbb]] ] = {
    context = {
      name = 'mathbb',
      dscr = 'Auto mathbb style',
    },
    command = [[\mathbb]],
  },
  [ [[([a-zA-Z0-9])mscr]] ] = {
    context = {
      name = 'mathscr',
      dscr = 'Auto mathscr style',
    },
    command = [[\mathscr]],
  },
  [ [[([a-zA-Z0-9])mcal]] ] = {
    context = {
      name = 'mathcal',
      dscr = 'Auto mathcal style',
    },
    command = [[\mathcal]],
  },
  [ [[([a-zA-Z0-9])mbf]] ] = {
    context = {
      name = 'mathbf',
      dscr = 'Auto mathbf style',
    },
    command = [[\mathbf]],
  },
}

for k, v in pairs(auto_capture_specs) do
  capture_wrap_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_mathzone })
end

local simple_command_snippet = utils.tex.snippet_templates.simple_command_snippet

local simple_command_specs = {
  mbb = {
    context = {
      name = 'mathbb',
      dscr = 'mathbb style',
    },
    command = [[\mathbb]],
  },
  mscr = {
    context = {
      name = 'mathscr',
      dscr = 'mathscr style',
    },
    command = [[\mathscr]],
  },
  mcal = {
    context = {
      name = 'mathcal',
      dscr = 'mathcal style',
    },
    command = [[\mathcal]],
  },
}

for k, v in pairs(simple_command_specs) do
  simple_command_snippet(vim.tbl_deep_extend('error', { trig = k, condition = in_mathzone }, v.context), v.command)
end
