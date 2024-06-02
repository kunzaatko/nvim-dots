for name, icon in pairs(static.icons.diagnostics) do
  name = 'DiagnosticSign' .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
end

vim.diagnostic.config {
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
