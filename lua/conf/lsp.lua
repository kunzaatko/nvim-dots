local cmd = vim.cmd

-- Used for swapfiles and the CursorHold event (autocommands for the LSP)
vim.opt.updatetime = 300

vim.diagnostic.config {
  virtual_text = {
    prefix = '● ', -- '■', '▎', 'x'
  },
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

-- diagnostic signs in the sign column
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  local col = 'Diagnostic' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = col })
end

-- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]]
