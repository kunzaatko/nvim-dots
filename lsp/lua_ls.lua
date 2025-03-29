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
    '.git',
  },
  log_level = vim.lsp.protocol.MessageType.Warning,
  single_file_support = 'true',
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      completion = {
        callSnippet = 'Replace',
      },
    },
  },
}
opts.capabilities = require('util.lsp').get_capabilities()
return opts
