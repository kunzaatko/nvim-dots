local cmd = vim.cmd

-- Used for swapfiles and the CursorHold event (autocommands for the LSP)
vim.opt.updatetime = 300

-- Enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = '● ', -- '■', '▎', 'x'
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- diagnostic signs in the sign column
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  local col = 'Diagnostic' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = col })
end

cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]]
