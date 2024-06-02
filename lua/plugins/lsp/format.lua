local M = {}

vim.g.autoformat = true

function M.toggle()
  vim.g.autoformat = not vim.g.autoformat
  -- TODO: notify <10-01-23>
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0

  vim.lsp.buf.format {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == 'null-ls'
      end
      return client.name ~= 'null-ls'
    end,
  }
end

function M.on_attach(client, buf)
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_create_user_command('LspFormat', M.format, {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. buf, {}),
      buffer = buf,
      callback = function()
        if vim.g.autoformat then
          M.format()
        end
      end,
    })
  end
end

return M
