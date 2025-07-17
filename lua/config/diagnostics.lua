local severity_names = {
  Error = vim.diagnostic.severity.ERROR,
  Warn = vim.diagnostic.severity.WARN,
  Info = vim.diagnostic.severity.INFO,
  Hint = vim.diagnostic.severity.HINT,
}
local sign_opts = {
  text = {},
  numhl = {},
}
for name, sname in pairs(severity_names) do
  local hl_name = 'DiagnosticSign' .. name
  sign_opts.numhl[sname] = hl_name
  sign_opts.text[sname] = static.icons.diagnostics[name]
end

---@type vim.diagnostic.Opts
vim.diagnostic.config {
  signs = sign_opts,
  underline = true,
  update_in_insert = false,
  ---@type vim.diagnostic.Opts.VirtualText
  virtual_text = {
    current_line = true,
    spacing = 4,
    prefix = '●',
    -- TODO: Use different prefixes for different severities using the format function <30-03-25>
  },
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    -- border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

-- Show errors and warnings in a floating window when pausing on an error --
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    -- TODO: Callback should remove the ghost-text that is my default view for a single diagnostic <06-07-25>
    vim.diagnostic.open_float(nil, {
      focusable = false,
      source = 'if_many',
      -- FIX: How to call on `User` events with custom patterns? <06-07-25>
      -- close_events = {  'User', { pattern = 'DocWinOpen' }  }
    })
  end,
})
