-- NOTE: Acts the same way as `romainl/vim-cool`. It activates `hlsearch` when searching and deactivates it otherwise
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
    if vim.o.hlsearch ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace 'auto_hlsearch')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = vim.api.nvim_create_augroup('HighlightYank', {}),
  callback = function()
    vim.hl.on_yank { higroup = 'Search', timeout = 300, on_visual = true, on_macro = false }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('HelpOptions', {}),
  pattern = 'help',
  callback = function()
    vim.opt_local.colorcolumn = { 0 }
  end,
})

-- FIX: This does not work when entering a new buffer. Currently it does not work when opening the `oil.nvim` buffer,
-- but it is possible that it does not work for more buffer types and scenarios. It uses nonrelative numbering when the
-- buffer is entered and it is in normal mode <19-10-24>
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

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('AutoFold on enter', {}),
  callback = function()
    if not (vim.tbl_contains(fold_ignored_fts, vim.bo.filetype) or vim.bo.buftype ~= '') then
      pcall(function()
        vim.cmd.loadview(1)
      end) -- pcall, since new files have no view yet
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '?*',
  callback = function()
    if
      not (vim.tbl_contains(fold_ignored_fts, vim.bo.filetype) or vim.bo.buftype ~= '' or vim.bo.buftype ~= 'nofile')
    then
      vim.cmd.mkview(1)
    end
  end,
})

_G.root_patterns = {
  all = { '.git', 'Makefile', 'Justfile', 'justfile', 'src' },
  julia = { 'Project.toml', 'Manifest.toml' },
  tex = { 'Tectonic.toml', 'build' },
  lua = { 'lazy-lock.json' },
  rust = { 'build' },
  html = { 'static' },
  css = { 'static' },
}

-- FIX: This is not working as intended for most LSP servers. It does not change the file's path and then there is
-- a problem when trying to save the file. This could be probably handled by some signal to the LSP, but more probably,
-- I should only use this for the filetypes for which the LSP is working correctly after the change of root. This only
-- affects LSPs that format, but probably the LSP does not report anything more if the root changes. <15-08-24>
local fixed = false
if fixed then
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'VimEnter' }, {
    group = vim.api.nvim_create_augroup('AutoRoot', {}),
    callback = function(ctx)
      if
        vim.tbl_contains({ 'prompt', 'terminal' }, vim.o.buftype)
        -- FIX: 'tex' and 'latex' formatting (or it may be the LSP) is not compatible with root changing  <08-08-24> 
        or vim.tbl_contains({ 'TelescopePrompt', 'latex', 'tex', 'julia', 'oil' }, vim.o.filetype)
      then
        return
      end
      local patterns = vim.tbl_extend('keep', _G.root_patterns['all'], _G.root_patterns[vim.o.filetype] or {})
      local root = vim.fs.root(ctx.buf, patterns)
      if root then
        vim.notify_once(
          root,
          vim.log.levels.INFO,
          { timeout = 20, title = 'AutoRoot', icon = static.icons.explorer.folder_move }
        )
        vim.uv.chdir(root)
      end
    end,
  })
end

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
bg_terminal_sync() -- first call after the colour-scheme load

vim.api.nvim_create_autocmd('UILeave', {
  callback = function()
    io.write '\027]111\027\\'
  end,
})

-- Set filetype for systemd and Podman Quadlet unit files
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('AddFileTypes', {}),
  -- stylua: ignore start
  pattern = { -- systemd unit files
    "*.service", "*.socket", "*.timer", "*.mount", "*.automount",
    "*.swap", "*.target", "*.path", "*.slice", "*.scope", "*.device",
    -- Podman Quadlet files
    "*.container", "*.volume", "*.network", "*.kube", "*.pod", "*.build", "*.image"
  }, -- stylua: ignore end
  callback = function()
    vim.bo.filetype = 'systemd'
  end,
})
