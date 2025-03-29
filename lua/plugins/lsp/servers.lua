local M = {
  jsonls = {},
  kotlin_language_server = {},
  taplo = {},
  html = { filetypes = { 'html', 'htmldjango' } },
  bashls = {},
  ccls = {},
  vimls = {},
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'off',
        },
      },
    },
  },
  harper_ls = {
    filetypes = { 'markdown', 'latex', 'tex', 'txt', 'html' },
    settings = {
      ['harper-ls'] = {
        linters = {
          spell_check = false,
          -- wrong_quotes = true,
        },
      },
    },
  },
}

return M
