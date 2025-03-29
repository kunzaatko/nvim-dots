-- https://github.com/latex-lsp/texlab/wiki/Configuration
local opts = {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  single_file_support = 'true',
  root_markers = { '.git', '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
  settings = {
    texlab = {
      formatterLineLength = 120,
      bibtexFormatter = 'texlab',
      build = {
        executable = 'tectonic',
        args = {
          '-X',
          'compile',
          '%f',
          '--synctex',
          '--keep-logs',
          '--keep-intermediates',
        },
      },
      forwardSearch = { executable = 'zathura', args = { '--synctex-forward', '%l:1:%f', '%p' } },
    },
  },
}
opts.capabilities = require 'util.lsp'.get_capabilities()

return opts
