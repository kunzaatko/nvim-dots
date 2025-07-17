local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
}

---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.ClientConfig
local opts = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = root_files,
  settings = {
    python = {
      analysis = {
        -- typeCheckingMode = 'off',
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
  single_file_support = true,
}

return opts
