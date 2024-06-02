local ls = require 'luasnip'

local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local fmta = require('luasnip.extras.fmt').fmta

local M = {}

-- TODO: Add limit 'indexing'
-- TODO: Add empty index for filling in
-- TODO: Automatically use the logical set for indexing (ex. n \in \N or i \in \hat{n|N}) <21-03-22>
-- TODO: Add indexing in Ball and similar
-- NOTE: Initial insert_nodes must be present in order to be able to change the choices from some
-- place
M.indexers = {
  discrete_set = function()
    return fmta([[<>_{<> \in <>}]], {
      i(1),
      c(2, { i(nil, 'n'), i(nil, 'i'), i(nil, 'j'), i(nil, 'k') }),
      c(3, {
        i(nil, [[\N]]),
        i(nil, [[\N_0]]),
        i(nil, [[\Z]]),
        i(nil, [[\Z^{+}]]),
        sn(nil, fmta([[\hat{<>}]], i(1, 'N'))),
        sn(nil, fmta([[\hat{<>}_0]], i(1, 'N'))),
      }),
    })
  end,
  continuous_set = function()
    return fmta([[<>_{<> \in <>}]], {
      i(1),
      c(2, { i(nil, 'x'), i(nil, 'y') }),
      c(3, { i(nil, [[\R]]), i(nil, [[\R^{+}]]), i(nil, [[\R^{-}]]) }),
    })
  end,
  -- TODO: Change the bounds not to use `=` with restoring the node in the index parameter
  discrete_bound = function()
    return fmta([[<>_{<> = <>}^{<>}]], {
      i(1),
      c(2, { i(nil, 'n'), i(nil, 'i'), i(nil, 'j'), i(nil, 'k') }),
      c(3, { i(nil, '0'), i(nil, '1'), i(nil, [[-\infty]]) }),
      c(4, { i(nil, 'N'), i(nil, [[+\infty]]) }),
    })
  end,
  continuous_bound = function()
    return fmta([[<>_{<>}^{<>}]], {
      -- TODO: Do this using a dynamic node that determines the logical value of the other bound
      i(1),
      c(2, { i(nil, '0'), i(nil, [[-\infty]]) }),
      c(3, { i(nil, [[+\infty]]), i(nil, '0') }),
    })
  end,
}

return M
