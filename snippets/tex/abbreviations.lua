local in_normalzone = utils.tex.conditions.in_normalzone

local abbrevs = {
  ['fce'] = 'funkce',
  ['fcí'] = 'funkcí',
  ['fci'] = 'funkci',
  ['Fci'] = 'Funkci',
  ['Fce'] = 'Funkce',
  ['Nť'] = 'Nechť',
  ['nť'] = 'nechť',
}

for trig, full in pairs(abbrevs) do
  s({
    trig = trig,
    name = full,
    docstring = full .. '{0}',
    dscr = 'abbreviation for ' .. full,
    snippetType = 'autosnippet',
    condition = in_normalzone,
  }, { t(full) })
end
