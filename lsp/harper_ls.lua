---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.Config
local opts = {
  filetypes = { 'markdown', 'latex', 'tex', 'txt', 'html' },
  settings = {
    ['harper-ls'] = {
      linters = {
        spell_check = false,
        -- wrong_quotes = true,
      },
    },
  },
}

return opts
