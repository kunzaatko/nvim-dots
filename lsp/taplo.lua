---@type  vim.lsp.Config
local opts = {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  single_file_support = true,
}
return opts
