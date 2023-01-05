_G.LSPUtils = _G.LSPUtils or {}

--- Sets mappings for LSP commands
---@param bufnr number
_G.LSPUtils.on_attach = function(_, bufnr)
  -- {{{
  -- NOTE: Activate on debuging LSP behaviour <kunzaatko> --
  -- vim.lsp.set_log_level 'debug'
  local map = vim.keymap.set

  require('lsp_signature').on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    hint_enable = false,
    hint_prefix = '',
    transparency = 10,
  }, bufnr)

  map('n', '<c-]>', vim.lsp.buf.definition, { silent = true, buffer = bufnr, desc = 'LSP definition' })
  map('n', 'K', vim.lsp.buf.hover, { silent = true, buffer = bufnr, desc = 'LSP hover' })
  map('n', 'gD', vim.lsp.buf.implementation, { silent = true, buffer = bufnr, desc = 'LSP implementation' })
  map('n', '<c-k>', vim.lsp.buf.signature_help, { silent = true, buffer = bufnr, desc = 'LSP signature help' })
  map('n', '1gD', vim.lsp.buf.type_definition, { silent = true, buffer = bufnr, desc = 'LSP type definition' })
  map('n', 'gr', vim.lsp.buf.references, { silent = true, buffer = bufnr, desc = 'LSP references' })
  map('n', 'g0', vim.lsp.buf.document_symbol, { silent = true, buffer = bufnr, desc = 'LSP document symbol' })
  map('n', 'gW', vim.lsp.buf.workspace_symbol, { silent = true, buffer = bufnr, desc = 'LSP workspace symbol' })
  map('n', 'gd', vim.lsp.buf.declaration, { silent = true, buffer = bufnr, desc = 'LSP declaration' })
  map('n', 'ga', vim.lsp.buf.code_action, { silent = true, buffer = bufnr, desc = 'LSP code action' })
  -- Goto previous/next diagnostic warning/error
  map('n', 'g[', vim.diagnostic.goto_prev, { silent = true, buffer = bufnr, desc = 'go to prev LSP diagnostic' })
  map('n', 'g]', vim.diagnostic.goto_next, { silent = true, buffer = bufnr, desc = 'go to next LSP diagnostic' })
  map('n', '<leader>F', vim.lsp.buf.format, { silent = true, buffer = bufnr, desc = 'LSP format' })
  map('v', '<leader>F', vim.lsp.buf.format, { silent = true, buffer = bufnr, desc = 'LSP format in range' })
end -- }}}
