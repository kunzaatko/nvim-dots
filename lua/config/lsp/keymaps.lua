local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)
  local which_key_exists, wk = pcall(require, 'which-key')

  if which_key_exists then
    -- FIX: Add icons through icon util <04-05-23>
    -- TODO: Add other groups <03-05-23>
    -- TODO: Do not list window mappings after leader <20-05-23>
    wk.add({
      {
        '<leader>l',
        group = 'LSP',
        icon = { icon = static.icons.lsp.lsp, color = 'blue' },
      },
    }, { buffer = 0 })
  end

  -- TODO: These mappings should be mapped to the lsp group <03-05-23>
  self:map('gl', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  self:map('<leader>ld', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

  local nvimlspconfig_exists, _ = pcall(require, 'nvim-lspconfig')
  if nvimlspconfig_exists then
    self:map('<leader>li', 'LspInfo', { desc = 'Lsp Info' })
  end
  local nullls_exists, _ = pcall(require, 'null-ls')
  if nullls_exists then
    self:map('<leader>lI', 'NullLsInfo', { desc = 'NullLs Info' })
  end

  local snacks_exists, _ = pcall(require, 'snacks')
  if snacks_exists then
    self:map('<leader>lD', Snacks.picker.diagnostics, { desc = 'Workspace Diagnostics' })
    self:map('<leader>ld', Snacks.picker.diagnostics_buffer, { desc = 'Buffer Diagnostics' })
    self:map('<leader>lS', Snacks.picker.lsp_workspace_symbols, { desc = 'LSP Workspace Symbols' })
    self:map('gO', Snacks.picker.lsp_symbols, { desc = 'LSP Symbols' })

    self:map('gd', Snacks.picker.lsp_definitions, { desc = 'Goto Definition' })
    self:map('gD', Snacks.picker.lsp_declarations, { desc = 'Goto Declaration' })
    self:map('gT', Snacks.picker.lsp_type_definitions, { desc = 'Goto Type Definition' })
    self:map('gI', Snacks.picker.lsp_implementations, { desc = 'Goto Implementation' })
    self:map('<leader>gr', Snacks.picker.lsp_references, { nowait = true, desc = 'References' })
  end

  local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
      vim.cmd('h ' .. vim.fn.expand '<cword>')
    elseif vim.tbl_contains({ 'man' }, filetype) then
      vim.cmd('Man ' .. vim.fn.expand '<cword>')
    elseif vim.fn.expand '%:t' == 'Cargo.toml' and require('crates').popup_available() then
      require('crates').show_popup()
    else
      vim.lsp.buf.hover()
    end
    vim.cmd.doautocmd 'User DocWinOpen'
  end

  self:map('K', show_documentation, { desc = 'Hover' })
  self:map('<leader>lh', vim.lsp.buf.signature_help, { desc = 'Signature Help', has = 'signatureHelp' })

  self:map('[d', M.diagnostic_goto(true), { desc = 'Next Diagnostic' })
  self:map(']d', M.diagnostic_goto(false), { desc = 'Prev Diagnostic' })
  self:map(']e', M.diagnostic_goto(true, vim.diagnostic.severity.ERROR), { desc = 'Next Error' })
  self:map('[e', M.diagnostic_goto(false, vim.diagnostic.severity.ERROR), { desc = 'Prev Error' })
  self:map(']w', M.diagnostic_goto(true, vim.diagnostic.severity.WARN), { desc = 'Next Warning' })
  self:map('[w', M.diagnostic_goto(false, vim.diagnostic.severity.WARN), { desc = 'Prev Warning' })

  -- self:map('gra', vim.lsp.buf.code_action, { desc = 'Code Action', mode = { 'n', 'v' }, has = 'codeAction' })
  self:map('grn', vim.lsp.buf.rename, { desc = 'Rename', has = 'rename' })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. 'Provider']
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or 'n',
    lhs,
    type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.diagnostic_goto(next, severity)
  local go = function()
    vim.diagnostic.jump {
      count = next and 1 or -1,
      float = true,
      severity = severity,
    }
  end
  return function()
    ---@diagnostic disable-next-line: need-check-nil
    go()
  end
end

return M
