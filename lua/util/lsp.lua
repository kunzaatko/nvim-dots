local M = {}

---@class utils.lsp.OnAttachOpts
---Options passed to the `on_attach` function for filtering the server that the on attach is triggered on.
---@field server_name string name of the server (default '*')

---@brief Register a call a function on attach of LSP
---@param on_attach fun(client, buffer):nil
---@param opts utils.lsp.OnAttachOpts|nil
function M.on_attach(on_attach, opts)
  local server_name = (opts and opts.server_name) or '*'
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if server_name == '*' or client.name == server_name then
        on_attach(client, buffer)
      end
    end,
  })
end

_G.lsp_client_capabilities = lsp_client_capabilities or vim.lsp.protocol.make_client_capabilities()

---@brief Add additional capabilities to the global LSP client capabilities.
---@param capabilities lsp.ClientCapabilities Table containing LSP capabilities to be added
---@return lsp.ClientCapabilities capabilities The updated LSP client capabilities
M.add_capabilities = function(capabilities)
  _G.lsp_client_capabilities = vim.tbl_deep_extend('force', _G.lsp_client_capabilities, capabilities)
  return _G.lsp_client_capabilities
end

---@brief Get the LSP client capabilities.
---@return lsp.ClientCapabilities capabilities LSP client capabilities.
M.get_capabilities = function()
  return _G.lsp_client_capabilities
end

return M
