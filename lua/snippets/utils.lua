local M = {}
local status_ok, comment_ft = pcall(require, 'Comment.ft')
if not status_ok then
  vim.api.nvim_err_writeln('Failed to load ' .. 'Comment.ft' .. '\n\n' .. comment_ft)
end

local calculate_comment_string = comment_ft.calculate
local region = require('Comment.utils').get_region
local has_treesitter, ts = pcall(require, 'vim.treesitter')

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
M.get_cstring = function(ctype)
  local cstring = calculate_comment_string { ctype = ctype, range = region() } or ''
  local cstring_table = vim.split(cstring, '%s', { plain = true, trimempty = true })
  if #cstring_table == 0 then
    return { '', '' }
  end
  return #cstring_table == 1 and { cstring_table[1], '' } or { cstring_table[1], cstring_table[2] }
end

--- Get the current node under the cursor if treesitter has a parser
M.get_node_at_cursor = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  -- FIX: This should be filed as an issue with treesitter because the parser language name and 'ft'
  -- option is inconsistent<14-09-22>
  local lang = vim.api.nvim_buf_get_option(0, 'ft')
  if lang == 'tex' then
    lang = 'latex'
  end
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
function M.in_comment(_, _, _)
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
end

return M
