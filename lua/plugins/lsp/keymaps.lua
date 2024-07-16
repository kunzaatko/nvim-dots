-- TODO: Create system that couples with the plugins that require the on_attach callback and joins these requirements
-- into one function <09-01-23>
local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)
  local wk = require 'which-key'

  -- TODO: Add icons through icon util <04-05-23>
  wk.add({
    { '<leader>l', group = string.format('%s %s', static.icons.lsp.lsp, 'LSP') },
  }, { buffer = 0 })

  -- TODO: These mappings should be mapped to the lsp group <03-05-23>
  self:map('gl', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  self:map('<leader>ld', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  self:map('<leader>li', 'LspInfo', { desc = 'Lsp Info' })
  self:map('<leader>lI', 'NullLsInfo', { desc = 'NullLs Info' })
  self:map('<leader>lD', 'Telescope diagnostics', { desc = 'Telescope Diagnostics' })

  self:map('gd', 'Telescope lsp_definitions', { desc = 'Goto Definition' })
  self:map('gD', 'Telescope lsp_declarations', { desc = 'Goto Declaration' })
  self:map('gT', 'Telescope lsp_type_definitions', { desc = 'Goto Type Definition' })
  self:map('gr', 'Telescope lsp_references', { desc = 'References' })
  self:map('gI', 'Telescope lsp_implementations', { desc = 'Goto Implementation' })

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
  end

  self:map('K', show_documentation, { desc = 'Hover' })
  self:map('<leader>lh', vim.lsp.buf.signature_help, { desc = 'Signature Help', has = 'signatureHelp' })

  self:map('[d', M.diagnostic_goto(true), { desc = 'Next Diagnostic' })
  self:map(']d', M.diagnostic_goto(false), { desc = 'Prev Diagnostic' })
  self:map(']e', M.diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
  self:map('[e', M.diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
  self:map(']w', M.diagnostic_goto(true, 'WARNING'), { desc = 'Next Warning' })
  self:map('[w', M.diagnostic_goto(false, 'WARNING'), { desc = 'Prev Warning' })

  self:map('<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action', mode = { 'n', 'v' }, has = 'codeAction' })

  -- TODO: Add symbols outline plug-in <12-05-23>
  local format = require('plugins.lsp.format').format
  self:map('<leader>lf', format, { desc = 'Format Document', has = 'documentFormatting' })
  self:map('<leader>lf', format, { desc = 'Format Range', mode = 'v', has = 'documentRangeFormatting' })
  self:map('<leader>lr', function()
    return ':IncRename ' .. vim.fn.expand '<cword>'
  end, { expr = true, desc = 'Rename', has = 'rename' })
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
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
