-- https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/Configuration.md
---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.Config
local opts = {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  single_file_support = true,
  settings = {
    formatterMode = 'typstyle',
    exportPdf = 'onType',
    semanticTokens = 'disable',
  },
}

return opts
