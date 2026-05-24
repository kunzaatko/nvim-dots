local opt = vim.opt

vim.b.disable_autoformat = true

local indent = 2
opt.expandtab, opt.shiftround = true, true
opt.tabstop, opt.shiftwidth = indent, indent

opt.wrap = true

local _, peek = pcall(require, 'peek')
vim.keymap.set('n', '<localleader>o', function()
  require('util.helpers').require_plugin('peek', peek.open)
end, { desc = 'open output with peek', buffer = true })

local _, render_markdown = pcall(require, 'render-markdown')
vim.keymap.set('n', '<localleader>r', function()
  require('util.helpers').require_plugin('render-markdown', render_markdown.buf_toggle)
end, {
  desc = 'toggle markdown rendering',
  buffer = true,
})
