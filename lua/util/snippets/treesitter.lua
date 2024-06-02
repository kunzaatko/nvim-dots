local M = {}

local has_treesitter, ts = pcall(require, 'vim.treesitter')
local make_condition = require('luasnip.extras.conditions').make_condition

--- Get the current node under the cursor if treesitter has a parser
M.get_node_at_cursor = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  local lang = vim.api.nvim_buf_get_option(0, 'ft')
  lang = lang == 'tex' and 'latex' or lang
  local ok, parser = pcall(ts.get_parser, 0, lang)
  if not ok or not parser then
    return
  end
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then
    return
  end

  return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

--- Check if the current cursor position is in a comment
---@return boolean in_comment
M.in_comment = make_condition(function(_, _, _)
  if not has_treesitter then
    return false
  end
  local node = M.get_node_at_cursor()
  while node do
    if node:type() == 'comment' then
      return true
    end
    node = node:parent()
  end
  return false
end)

return M
