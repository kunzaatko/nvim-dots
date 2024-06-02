local M = {}

--- Remove trailing whitespace in the current buffer
function M.remove_trailing_whitespace()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd [[%s/\s\+$//e]]
  vim.fn.setpos('.', save_cursor)
end

--- Get visual selection position
function M.get_vsel()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local start = vim.fn.getpos 'v' -- [bufnum, lnum, col, off]
  local _end = vim.fn.getpos '.' -- [bufnum, lnum, col, off]
  return {
    bufnr = bufnr,
    mode = vim.fn.mode(),
    pos = { start[2], start[3], _end[2], _end[3] },
  }
end

--- Returns the text selected in visual mode in the current buffer.
--- @return string[]: The text selected in visual mode in the current buffer.
function M.get_vsel_text()
  local vsel = M.get_vsel()
  local pos = vsel.pos
  if vsel.mode == 'v' then
    return vim.api.nvim_buf_get_text(0, pos[1] - 1, pos[2] - 1, pos[3] - 1, pos[4], {})
  elseif vsel.mode == 'V' then
    return vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[3], true)
  end
  error('Invalid mode: ' .. vsel.mode, 2)
end

function M.exit_vmode()
  local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
  vim.api.nvim_feedkeys(esc, 'x', false)
end

---@return boolean
local function is_vsel_line_mode()
  local modeWithV = vim.fn.mode():find 'V'
  return modeWithV ~= nil
end

---sets the selection for the textobj (linewise)
---@param startline integer
---@param endline integer
local function set_linewise_selection(startline, endline)
  vim.api.nvim_win_set_cursor(0, { startline, 0 })
  if not is_vsel_line_mode() then
    vim.cmd.normal { 'V', bang = true }
  end
  vim.cmd.normal { 'o', bang = true }
  vim.api.nvim_win_set_cursor(0, { endline, 0 })
end

-- TODO: Select with no cursor movement <29-10-23, kunzaatko>
function M.entire_buffer()
  local lastLine = vim.api.nvim_buf_line_count(0)
  set_linewise_selection(1, lastLine)
end

M.terminal = require 'util.terminal'
M.project = require 'util.project'
M.lsp = require 'util.lsp'

-- TODO: Make a generic REPL function and a generic oneshot terminal function to use from ftplugin <14-05-23>

return M
