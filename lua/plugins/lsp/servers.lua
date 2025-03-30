local M = {
  jsonls = {},
  kotlin_language_server = {},
  html = { filetypes = { 'html', 'htmldjango' } },
  bashls = {},
  ccls = {},
  vimls = {},
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
