-- NOTE: Acts the same way as `romainl/vim-cool`. It activates `hlsearch` when searching and deactivates it otherwise
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace 'auto_hlsearch')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('HighlightYank', {}),
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 300, on_visual = true, on_macro = false }
  end,
})

-- TODO: Add foldlevel, when leaving a window? <17-04-23>
vim.api.nvim_create_augroup('NumberToggle', {})
vim.api.nvim_create_autocmd({ 'WinEnter', 'InsertLeave' }, {
  desc = 'Enable `relativenumber` when focusing a buffer',
  group = 'NumberToggle',
  callback = function()
    if vim.opt_local.number:get() == true then
      vim.opt_local.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'InsertEnter' }, {
  desc = 'Disable `relativenumber` when unfocusing a buffer',
  group = 'NumberToggle',
  callback = function()
    if vim.opt_local.number:get() == true then
      vim.opt_local.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('VimStartup', {}),
  desc = 'Restore position from the previous editing when entering reading buffer',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local fold_ignored_fts = {
  'TelescopePrompt',
  'DressingSelect',
  'DressingInput',
  'toggleterm',
  'gitcommit',
  'replacer',
  'harpoon',
  'help',
  'qf',
}

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Close filetypes with `q`',
  group = vim.api.nvim_create_augroup('q_close_windows', { clear = true }),
  callback = function(event)
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = event.buf })
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })
    if buftype == 'nofile' or filetype == 'help' then
      vim.opt_local.buflisted = false
      vim.keymap.set('n', 'q', vim.cmd.close, { buffer = event.buf, silent = true, nowait = true })
    end
    if not (vim.tbl_contains(fold_ignored_fts, filetype) or buftype ~= '') then
      pcall(function()
        vim.cmd.loadview(1)
      end) -- pcall, since new files have no view yet
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '?*',
  callback = function()
    if not (vim.tbl_contains(fold_ignored_fts, vim.bo.filetype) or vim.bo.buftype ~= '') then
      vim.cmd.mkview(1)
    end
  end,
})

_G.root_patterns = {
  all = { '.git', 'Makefile', 'src' },
  julia = { 'Project.toml', 'Manifest.toml' },
  tex = { 'Tectonic.toml', 'build' },
  rust = { 'build' },
  html = { 'static' },
  css = { 'static' },
}
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('AutoRoot', {}),
  callback = function(ctx)
    local patterns = vim.tbl_extend('keep', _G.root_patterns['all'], _G.root_patterns[vim.o.filetype] or {})
    local root = vim.fs.root(ctx.buf, patterns)
    if root then
      vim.uv.chdir(root)
    end
  end,
})

-- Change the background colour of the terminal to match Neovim
local bg_terminal_sync = function()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  if not normal.bg then
    return
  end
  io.write(string.format('\027]11;#%06x\027\\', normal.bg))
end

vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  callback = bg_terminal_sync,
})
bg_terminal_sync() -- first call after the colorscheme load

vim.api.nvim_create_autocmd('UILeave', {
  callback = function()
    io.write '\027]111\027\\'
  end,
})
