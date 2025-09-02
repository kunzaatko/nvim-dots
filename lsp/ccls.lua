local function switch_source_header(client, bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify 'corresponding file cannot be determined'
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

-- FIX: This does not work... Gives the following server error:
-- ```
-- Error executing vim.schedule lua callback: ...re/bob/v0.11.0/share/nvim/runtime/lua/vim/lsp/client.lua:548: RPC[Error] code_name = InvalidParams, message = "invalid params of initialize: expected array for /workspaceFolders"
-- stack traceback:
--         [C]: in function 'assert'
--         ...re/bob/v0.11.0/share/nvim/runtime/lua/vim/lsp/client.lua:548: in function ''
--         vim/_editor.lua: in function <vim/_editor.lua:0>
-- ```
-- I should look how the server is set up in `nvim-lspconfig` <30-03-25>

---@diagnostic disable-next-line: undefined-doc-name
---@type  vim.lsp.Config
return {
  cmd = { 'ccls' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  offset_encoding = 'utf-32',
  -- ccls does not support sending a null root directory
  workspace_required = true,
  root_markers = { 'compile_commands.json', '.ccls' },
  init_options = {
    compilationDatabaseDirectory = 'build',
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { '-frounding-math' },
    },
  },
  on_attach = function(client)
    vim.api.nvim_buf_create_user_command(0, 'LspCclsSwitchSourceHeader', function()
      switch_source_header(client, 0)
    end, { desc = 'Switch between source/header' })
  end,
}
