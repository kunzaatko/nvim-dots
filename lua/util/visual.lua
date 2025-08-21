local M = {}

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
--- @return string[]: The text selected in visual mode in the current buffer as a list of lines. You can call
--- `table.concat` to get the true text of the selection.
function M.get_vsel_text()
  local vsel = M.get_vsel()
  local pos = vsel.pos
  if vsel.mode == 'v' then
    local start_row = (pos[1] < pos[3]) and (pos[1] - 1) or (pos[3] - 1)
    local end_row = (pos[1] < pos[3]) and (pos[3] - 1) or (pos[1] - 1)
    local start_col = (pos[2] - 1 < pos[4]) and pos[2] - 1 or pos[4] - 1
    local end_col = (pos[2] - 1 < pos[4]) and pos[4] or pos[2]
    return vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
  elseif vsel.mode == 'V' then
    local start_row = (pos[1] - 1 < pos[3] - 1) and pos[1] - 1 or pos[3] - 1
    local end_row = (pos[1] < pos[3]) and pos[3] or pos[1]
    return vim.api.nvim_buf_get_lines(0, start_row, end_row, true)
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

return M
