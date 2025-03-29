require('util').lsp.on_attach(function(client, buffer)
  require('config.lsp.keymaps').on_attach(client, buffer)
end)

-- NOTE: Closes the LSP connection with when last buffer detaches from the server <28-03-25>
vim.api.nvim_create_autocmd({ 'LspDetach' }, {
  group = vim.api.nvim_create_augroup('LspStopWithLastClient', {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.attached_buffers then
      return
    end
    for buf_id in pairs(client.attached_buffers) do
      if buf_id ~= args.buf then
        return
      end
    end
    client:stop()
  end,
  desc = 'Stop lsp client when no buffer is attached',
})
