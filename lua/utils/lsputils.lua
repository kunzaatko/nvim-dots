_G.LSPUtils = LSPUtils or {}

--- Sets mappings for LSP commands
---@param bufnr number
LSPUtils.on_attach = function( _, bufnr )
  -- {{{
  local map_loc = vim.api.nvim_buf_set_keymap

  map_loc(
    bufnr, 'n', '<c-]>', "<Cmd>lua vim.lsp.buf.definition()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'gD', "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', '<c-k>', "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', '1gD', "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'g0', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'gW', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'gd', "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'ga', "<Cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>",
    { noremap = true, silent = true }
  )

  -- Goto previous/next diagnostic warning/error
  map_loc(
    bufnr, 'n', 'g[', "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', 'g]', "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'n', '<leader>f', "<Cmd> lua vim.lsp.buf.formatting()<CR>",
    { noremap = true, silent = true }
  )
  map_loc(
    bufnr, 'v', '<leader>f', "<Cmd> lua vim.lsp.buf.range_formatting()<CR>",
    { noremap = true, silent = true }
  )
end -- }}}

return LSPUtils
