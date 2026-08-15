-- vim.opt_local.formatoptions:append 'a'

-- Re-wrap the commit body (lines 2:) with the built-in `gw` formatter on paste,
-- leaving the subject (line 1) untouched. <15-08-26>
--
-- NOTE: `gww` is `gw` applied to the current line, and `gw` ignores `formatexpr`
-- and `formatprg` (unlike `gq`), so this rewraps using only `textwidth` and
-- `formatoptions` -- identical to running `gww`.
--
-- A buffer-local `p` mapping does the paste (+ jump to end of pasted text, as
-- the global config does) and then re-wraps the body. This build of Neovim
-- (v0.12.3 via `bob`) has no `TextPutPost` event, so a keymap is the reliable
-- way to hook pasting. The reformat runs on a schedule so the paste settles
-- first.

--- Format the buffer body from line 2 to the last line with `gw`.
---@param buf integer: buffer handle
local function format_body(buf)
  local first = 2
  local last = vim.api.nvim_buf_line_count(buf)
  if last < first then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win)

    vim.api.nvim_win_set_cursor(win, { first, 0 })
    vim.cmd 'normal! V' -- start a line-wise visual selection
    vim.api.nvim_win_set_cursor(win, { last, 0 })
    vim.cmd 'normal! gw' -- format the selection as `gww`

    -- restore the cursor (`gw` usually keeps it in place, but be safe)
    vim.api.nvim_win_set_cursor(win, cursor)
  end)
end

vim.keymap.set('n', 'p', function()
  vim.cmd 'normal! p`]' -- paste and go to the end of the pasted text
  vim.schedule(function()
    format_body(vim.api.nvim_get_current_buf())
  end)
end, {
  desc = 'paste and reformat the commit body',
  buffer = true,
  silent = true,
})
