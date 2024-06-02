local M = {}

---Call a function on attach of LSP
---@param on_attach fun(client, buffer)
---@param opts table|nil
---- server_name string name of the server (default '*')
function M.on_attach(on_attach, opts)
  local server_name = (opts and opts.server_name) or '*'
  vim.api.nvim_create_autocmd('LspAttach', {
    pattern = server_name,
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

return M
