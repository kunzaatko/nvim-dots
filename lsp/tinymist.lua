-- https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/Configuration.md
local opts = {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_markers = { '.git' },
  single_file_support = true,
  settings = {
    formatterMode = 'typstyle',
    exportPdf = 'onType',
    semanticTokens = 'disable',
  },
}
opts.capabilities = require('util.lsp').get_capabilities()

return opts
