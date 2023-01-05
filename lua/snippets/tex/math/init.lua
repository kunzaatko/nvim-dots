for _, v in ipairs {
  'commands',
  'conveniences',
  'delimiters',
  'environments',
  'fonts',
  'matrices',
  'symbols',
} do
  require('snippets.tex.math.' .. v)
end
