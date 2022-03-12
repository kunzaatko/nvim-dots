_G.LSPUtils = _G.LSPUtils or {}

--- Sets mappings for LSP commands
---@param bufnr number
_G.LSPUtils.on_attach = function(_, bufnr)
  -- {{{
  -- NOTE: Activate on debuging LSP behaviour <kunzaatko> --
  -- vim.lsp.set_log_level 'debug'
  local map = vim.keymap.set

  map('n', '<c-]>', vim.lsp.buf.definition, { silent = true, buffer = bufnr })
  map('n', 'K', vim.lsp.buf.hover, { silent = true, buffer = bufnr })
  map('n', 'gD', vim.lsp.buf.implementation, { silent = true, buffer = bufnr })
  map('n', '<c-k>', vim.lsp.buf.signature_help, { silent = true, buffer = bufnr })
  map('n', '1gD', vim.lsp.buf.type_definition, { silent = true, buffer = bufnr })
  map('n', 'gr', vim.lsp.buf.references, { silent = true, buffer = bufnr })
  map('n', 'g0', vim.lsp.buf.document_symbol, { silent = true, buffer = bufnr })
  map('n', 'gW', vim.lsp.buf.workspace_symbol, { silent = true, buffer = bufnr })
  map('n', 'gd', vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
  map('n', 'ga', vim.lsp.buf.code_action, { silent = true, buffer = bufnr })
  -- Goto previous/next diagnostic warning/error
  map('n', 'g[', vim.diagnostic.goto_prev, { silent = true, buffer = bufnr })
  map('n', 'g]', vim.diagnostic.goto_next, { silent = true, buffer = bufnr })
  map('n', '<leader>F', vim.lsp.buf.formatting, { silent = true, buffer = bufnr })
  map('v', '<leader>F', vim.lsp.buf.range_formatting, { silent = true, buffer = bufnr })
end -- }}}
