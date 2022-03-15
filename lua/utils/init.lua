--- A shorthand for print(vim.inspct)
---@vararg table to inspect
_G.p = function(...)
  print(vim.inspect(...))
end
