local M = {}

local status_ok, comment_ft = pcall(require, 'Comment.ft')
if not status_ok then
  vim.api.nvim_err_writeln('Failed to load ' .. 'Comment.ft' .. '\n\n' .. comment_ft)
end

local calculate_comment_string = comment_ft.calculate
local region = require('Comment.utils').get_region

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

return M
