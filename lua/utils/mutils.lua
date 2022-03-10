-- map utilities
_G.MUtils = {}

_G.MUtils.append_blank_lines = function()
  vim.fn.append(vim.api.nvim_win_get_cursor(0)[1], vim.fn['repeat']({ '' }, vim.api.nvim_get_vvar 'count1'))
end

-- FIX: Does not work <09-05-21, kunzaatko> --
-- NOTE: It is maybe better to edit those files with sudoedit cli <kunzaatko> --
_G.MUtils.save_root = function()
  vim.fn.execute 'silent! write !sudo tee % >/dev/null | edit!<CR>'
end
