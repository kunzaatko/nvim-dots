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

_G.lsp_client_capabilities = lsp_client_capabilities or vim.lsp.protocol.make_client_capabilities()

--- Adds additional capabilities to the global LSP client capabilities.
--- @param capabilities table Table containing LSP capabilities to be added
--- @return table The updated LSP client capabilities
M.add_capabilities = function(capabilities)
  _G.lsp_client_capabilities = vim.tbl_deep_extend('force', _G.lsp_client_capabilities, capabilities)
  return _G.lsp_client_capabilities
end

return M
