local M = {}

--- Remove trailing whitespace in the current buffer
function M.remove_trailing_whitespace()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[%s/\s\+$//e]]
  vim.fn.setpos('.', save_cursor)
end

M.visual = require 'util.visual'
M.terminal = require 'util.terminal'
M.project = require 'util.project'
M.lsp = require 'util.lsp'
M.keymap = require 'util.keymap'

return M
