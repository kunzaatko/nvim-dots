local M = {
  snippets = {},
  autosnippets = {},
}

local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local m = require('luasnip.extras').match
local fmta = require('luasnip.extras.fmt').fmta

table.insert(
  M.snippets,
  s(
    {
      trig = 'req',
      name = 'require as local variable',
      dscr = 'require a module and bind it to a local variable',
      docstring = { [[local {3:c} = require '{1:a.b.c}'{0}]], [[local {3:c} = require({1:'a.b'}).{2:c}{0}]] },
    },
    fmta([[local <> = require<>'<>'<><>]], {
      d(3, function(args)
        local module_parts = vim.split(args[1][1], '.', true)
        local module_tail = module_parts[#module_parts] or ''
        local table_parts = vim.split(args[2][1], '.', true)
        local table_tail = table_parts[#table_parts]
        table_tail = table_tail ~= '' and table_tail or nil
        local var_name = table_tail or module_tail
        print(var_name)
        return sn(1, i(1, var_name))
      end, { 1, 2 }),
      m(2, [[.+]], ' (', ''),
      i(1),
      m(2, [[.+]], ').', ''),
      i(2),
    })
  )
)

ls.add_snippets('lua', M.snippets, { type = 'snippets', key = 'lua' })
