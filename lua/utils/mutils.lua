
-- map utilities
_G.MUtils = {}

MUtils.append_blank_lines = function()
  vim.fn.append(vim.fn.line("."),
                vim.fn["repeat"]({""}, vim.api.nvim_get_vvar("count1")))
end

-- TODO: Does not work <09-05-21, kunzaatko> --
MUtils.save_root = function()
  vim.fn.execute("silent! write !sudo tee % >/dev/null | edit!<CR>")
end
