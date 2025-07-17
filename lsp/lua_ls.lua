---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.ClientConfig
local opts = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    'lua/',
    'lazy-lock.json',
    'init.lua',
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  },
  log_level = vim.lsp.protocol.MessageType.Warning,
  single_file_support = 'true',
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },

      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
      },
      doc = {
        privateName = { '^_' },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = 'Disable',
        semicolon = 'Disable',
        arrayIndex = 'Disable',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
}
return opts
