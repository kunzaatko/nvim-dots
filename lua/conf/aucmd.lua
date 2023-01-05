_G.AUtils = {}
local AUtils = _G.AUtils
local api = vim.api

api.nvim_create_augroup('TelescopeFolding', {})
api.nvim_create_autocmd('FileType', {
  pattern = { 'TelescopePrompt', 'TelescopeResults' },
  group = 'TelescopeFolding',
  desc = 'Do not fold in Telescope',
  callback = function()
    vim.opt_local.foldmethod = 'manual'
  end,
})

-- restore cursor position (" -- mark of last cursor position)
api.nvim_create_augroup('VimStartup', {})
api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  group = 'VimStartup',
  desc = 'Restore position from the previous editing when entering reading buffer',
  command = [[if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif]],
})

-- highlight yanked text
api.nvim_create_augroup('HighlightYank', {})
api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  desc = 'Highlight yanked text',
  group = 'HighlightYank',
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 300, on_visual = true, on_macro = false }
  end,
})

-- turn off relative numbering when leaving the buffer
api.nvim_create_augroup('NumberToggle', {})
api.nvim_create_autocmd({ 'WinEnter', 'InsertLeave' }, {
  pattern = '*',
  desc = 'Enable `relativenumber` when focusing a buffer',
  group = 'NumberToggle',
  callback = function()
    if vim.wo.number == true then
      vim.wo.relativenumber = true
    end
  end,
})
api.nvim_create_autocmd({ 'WinLeave', 'InsertEnter' }, {
  pattern = '*',
  desc = 'Disable `relativenumber` when unfocusing a buffer',
  group = 'NumberToggle',
  callback = function()
    if vim.wo.number == true then
      vim.wo.relativenumber = false
    end
  end,
})

-- trim white-space after leaving the buffer
AUtils.trim_white_space = function()
  if vim.b.noTrimWhiteSpace or not vim.o.modifiable then
    return
  end
  vim.cmd '%s/\\s\\+$//e'
end

-- FIX: Julia has to be here because of a bug in the language server julia-vscode/julia-vscode#2526, where this crashes
-- the server <19-02-22, kunzaatko> --
api.nvim_create_augroup('TrimWhiteSpace', {})
api.nvim_create_autocmd('FileType', {
  pattern = { 'matlab', 'julia' },
  desc = 'Disable trimming trailing whitespace in filetypes',
  group = 'TrimWhiteSpace',
  callback = function()
    vim.b.noTrimWhiteSpace = true
  end,
})
api.nvim_create_autocmd('FileType', {
  desc = 'Trim trailing whitespace',
  group = 'TrimWhiteSpace',
  callback = _G.AUtils.trim_white_space,
})

-- does not use neovim inbuilt spell checker on these filetypes
api.nvim_create_augroup('SetNoSpell', {})
api.nvim_create_autocmd('FileType', {
  pattern = { 'man', 'gitrebase' },
  desc = 'Do not spell in particular filetypes',
  group = 'SetNoSpell',
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- formatting option for different filetypes
api.nvim_create_augroup('FormatOptions', {})
api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  desc = 'Do not preserve comment for Lua when `o` is pressed',
  group = 'FormatOptions',
  callback = function()
    vim.opt_local.formatoptions:remove 'o'
  end,
})
