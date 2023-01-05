_G.luasnip = {}
_G.luasnip.vars = {
  username = 'kunzaatko',
  email = 'martinkunz@email.cz',
  github = 'https://github.com/kunzaatko',
  real_name = 'Martin Kunz',
  date_format = '%d-%m-%y',
}
_G.luasnip._cache = {}

for _, v in ipairs { 'all', 'tex', 'lua' } do
  require('snippets.' .. v)
end
