local has_treesitter, ts = pcall(require, 'vim.treesitter')
local get_node_at_cursor = require('util.snippets.treesitter').get_node_at_cursor
local make_condition = require('luasnip.extras.conditions').make_condition
local M = {}

--- Checks whether the cursor is in a zone defined by environments and nodes
---@param zone_environments table[boolean] environments that specify the zone
---@param zone_nodes  table[boolean] nodes that specify the zone
---@param opts nil|table[boolean]
---              - no_environment: default when cursor position is not in any environment (false)
---              - no_treesitter: default when if the filetype does not have treesitter (true)
---              - default: output when no match (false)
---@return boolean in_zone `true` if the current node is leaf of node of type 'environment' with the name in
---`zone_environments` or if it is a leaf of a node of a type in `zone_nodes` otherwise `false`
local function in_region(zone_environments, zone_nodes, opts)
  opts = opts or {}
  vim.tbl_extend('keep', opts, { no_environment = false, no_treesitter = true, default = false })
  if not has_treesitter then
    return opts.no_treesitter
  end
  local no_env = true
  local buf = vim.api.nvim_get_current_buf()
  local node = get_node_at_cursor()
  while node do
    if zone_nodes[node:type()] ~= nil then
      return zone_nodes[node:type()]
    end

    if node:type() == 'generic_environment' then
      local begin = node:child(0)
      local names = begin and begin:field 'name'

      if names and names[1] then
        local env_name = ts.get_node_text(names[1], buf):match '{([a-zA-Z%d%*]*)}'
        if zone_environments[env_name] ~= nil then
          return zone_environments[env_name]
        end
      end
      no_env = false
    end
    node = node:parent()
  end
  if no_env then
    return opts.no_environment
  else
    return opts.default
  end
end

local MATH_ENVIRONMENTS = { -- in_mathzone
  -- math = true,
  displaymath = true,
  equation = true,
  [ [[equation*]] ] = true,
  multline = true,
  eqnarray = true,
  align = true,
  [ [[align*]] ] = true,
  array = true,
  split = true,
  alignat = true,
  gather = true,
  flalign = true,
  [ [[flalign*]] ] = true,
  aligned = true,
}
local MATH_NODES = {
  math_environment = true,
  displayed_equation = true,
  inline_formula = true,
  text_mode = false,
}

-- NOTE: When inserting _ treesitter parses underscore and it thinks that it is in
-- mathzone even when it is not <23-05-23>
-- FIX: Add a condition that overcomes this issue <23-05-23>
--- Check whether the current position in the buffer is in a math region
---@return boolean in_mathzone `true` when in a zone expecting math commands else `false`
M.in_mathzone = make_condition(function(_, _, _)
  return in_region(MATH_ENVIRONMENTS, MATH_NODES)
end)

local DOCUMENT_ENVIRONMENTS = { -- in_document
  document = true,
}

-- FIX: This should be implemented differently because now it always returns true <29-09-22>
--- Check whether the current position if the buffer is in the document
---@return boolean in_document `true` when in the `document` environment else `false`
M.in_document = make_condition(function(_, _, _)
  return in_region(DOCUMENT_ENVIRONMENTS, {}, { no_environment = true, default = true })
end)

--- Check whether the current position in the buffer is in the preamble
---@return boolean in_preamble `true` when before start of `document` environment
M.in_preamble = -M.in_document

--- Check whether the current position in the buffer is in a normal region
---@return boolean in_normalzone `true` in document but not in a math region
M.in_normalzone = M.in_document * -M.in_mathzone
--- Check that cursor is after a math variable (that can be followed by an exponent or subscript)
---@return boolean after_math_variable
---returns `true` if the cursor is after any variable that can be sub or sup scripted or otherwise manipulated using
--- LaTeX operators like overline etc.
M.after_math_variable = make_condition(function(_, _, _)
  -- TODO: Only temporary <20-03-22>
  return M.in_mathzone(nil, nil, nil)
end)

local ALIGNEMENT_ENVIRONMENTS = { -- in_alignment
  align = true,
  [ [[align*]] ] = true,
  flalign = true,
  [ [[flalign*]] ] = true,
  aligned = true,
  split = true,
}

--- Checks whether current position in the buffer is in some math alignment environment
---@return boolean in_alignment `true` when in one of `ALIGNEMENT_ENVIRONMENTS`
M.in_alignment = make_condition(function(_, _, _)
  return in_region(ALIGNEMENT_ENVIRONMENTS, {})
end)

local LIST_ENVIRONMENTS = { -- in_list
  itemize = true,
  enumerate = true,
  description = true,
}

--- Checks whether current position in the buffer is in some list environment
---@return boolean in_list `true` when in one of `LIST_ENVIRONMENTS`
M.in_list = make_condition(function(_, _, _)
  return in_region(LIST_ENVIRONMENTS, {})
end)

return M
