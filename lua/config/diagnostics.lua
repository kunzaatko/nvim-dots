local severity_names = {
  Error = vim.diagnostic.severity.ERROR,
  Warn = vim.diagnostic.severity.WARN,
  Info = vim.diagnostic.severity.INFO,
  Hint = vim.diagnostic.severity.HINT,
}
local sign_opts = {
  text = {},
  numhl = {},
}
for name, sname in pairs(severity_names) do
  local hl_name = 'DiagnosticSign' .. name
  sign_opts.numhl[sname] = hl_name
  sign_opts.text[sname] = static.icons.diagnostics[name]
end

vim.diagnostic.config {
  signs = sign_opts,
  underline = true,
  update_in_insert = false,
  virtual_text = false, -- set in lua/plugins/lsp/init.lua with lsp_lines
  -- virtual_text = { spacing = 4, prefix = '●' }, -- '■', '▎', 'x'
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}
