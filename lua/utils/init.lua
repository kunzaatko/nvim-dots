--- A shorthand for print(vim.inspct)
---@vararg table to inspect
_G.p = function(...)
  print(vim.inspect(...))
end

local M = {}

M.tbl_copy = function(t)
  local u = {}
  for k, v in pairs(t) do
    u[k] = v
  end
  return setmetatable(u, getmetatable(t))
end

return M
