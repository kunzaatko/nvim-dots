local wk = require 'which-key'

-- TODO: Add other groups <03-05-23>
-- TODO: Do not list window mappings after leader <20-05-23>
wk.add {
  { '<leader>a', group = string.format('%s %s', static.icons.ai, 'AI') },
  { '<leader>f', group = string.format('%s %s', static.icons.find, 'Find') },
  { '<leader>g', group = string.format('%s %s', static.icons.git.git, 'Git') },
  { '<leader>s', group = string.format('%s %s', static.icons.snippets, 'Snippets') },
  { '<leader>t', group = string.format('%s %s', static.icons.terminal, 'Terminal') },
  { '<leader>u', group = ' UI' },
}

-- Command line shortcuts
vim.keymap.set('n', ',w', vim.cmd.write, { silent = false, desc = 'write buffer' })
vim.keymap.set('n', ',q', vim.cmd.quit, { silent = false, desc = 'quit window' })
vim.keymap.set('n', ',wq', vim.cmd.xit, { silent = false, desc = 'write and quit' })
vim.keymap.set('n', ',,', ':', { desc = 'command line' })

-- View manipulation
vim.keymap.set('n', '|', vim.cmd.vsplit, { desc = 'split vertical' })
vim.keymap.set('n', '\\', vim.cmd.split, { desc = 'split horizontal' })
vim.keymap.set('n', ']t', vim.cmd.tabnext, { desc = 'next tab' })
vim.keymap.set('n', '[t', vim.cmd.tabprevious, { desc = 'previous tab' })

-- Text Objects
vim.keymap.set({ 'o', 'x' }, 'ae', require('util').entire_buffer, { desc = 'entire buffer textobj' })
vim.keymap.set({ 'o', 'x' }, 'ie', require('util').entire_buffer, { desc = 'entire buffer textobj' })

local append_blank_lines = function()
  vim.fn.append(vim.api.nvim_win_get_cursor(0)[1], vim.fn['repeat']({ '' }, vim.api.nvim_get_vvar 'count1'))
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufReadPost' }, {
  group = vim.api.nvim_create_augroup('modifying keymaps', {}),
  desc = 'Create keymaps that are applicable only to modifiable buffers',
  callback = function()
    if vim.opt.modifiable:get() then
      if vim.opt.filetype:get() ~= 'oil' then
        vim.keymap.set('n', '<CR>', append_blank_lines, { silent = true, desc = 'append blank lines', buffer = 0 })
      end
      vim.keymap.set('v', '>', '>gv', { desc = 'indent and reselect', buffer = 0 }) -- reselect after >>
      vim.keymap.set('v', '<', '<gv', { desc = 'dedent and reselect', buffer = 0 }) -- reselect after <<
      vim.keymap.set({ 'n', 'v' }, 'p', 'p`]', { silent = true, desc = 'paste', buffer = 0 }) -- go to end of pasted text
      -- vim.keymap.set('n', '<leader>s', ':%s/', { desc = 'substitute', buffer = 0 })
      -- vim.keymap.set('n', '<leader>S', ':%s/\\v', { desc = 'substitute with verymagic', buffer = 0 })
      vim.keymap.set('v', '<leader>s', ':s/', { desc = 'substitute in VISUAL', buffer = 0 })
      vim.keymap.set('v', '<leader>S', ':s/\\v', { desc = 'substitute in VISUAL with verymagic', buffer = 0 })
    end
  end,
})

-- UI

vim.keymap.set('n', '<leader><leader>', '<cmd>e #<CR>', { desc = 'open alternate-file' })

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufReadPost' }, {
  group = vim.api.nvim_create_augroup('fold openings with `h`', {}),
  callback = function()
    if vim.opt.filetype:get() ~= 'tex' then
      vim.keymap.set('n', 'h', function()
        local onIndentOrFirstNonBlank = vim.fn.virtcol '.' <= vim.fn.indent '.' + 1
        local shouldCloseFold = vim.tbl_contains(vim.opt_local.foldopen:get(), 'hor')
        if onIndentOrFirstNonBlank and shouldCloseFold then
          local wasFolded = pcall(vim.cmd.normal, 'zc')
          if wasFolded then
            return
          end
        end
        vim.cmd.normal { 'h', bang = true }
      end, { desc = 'h (+ close fold at BoL)', buffer = true, silent = true })
    end
  end,
})

vim.opt.foldopen:remove { 'search' } -- no auto-open when searching, since the following snippet does that better

vim.keymap.set('n', '/', 'zn/', { desc = 'Search & Pause Folds' })
vim.on_key(function(char)
  local key = vim.fn.keytrans(char)
  local searchKeys = { 'n', 'N', '*', '#', '/', '?' }
  local searchConfirmed = (key == '<CR>' and vim.fn.getcmdtype():find '[/?]' ~= nil)
  if not (searchConfirmed or vim.fn.mode() == 'n') then
    return
  end
  local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))

  local pauseFold = vim.opt.foldenable:get() and searchKeyUsed
  local unpauseFold = not (vim.opt.foldenable:get()) and not searchKeyUsed
  if pauseFold then
    vim.opt.foldenable = false
  elseif unpauseFold then
    vim.opt.foldenable = true
    vim.cmd.normal 'zv' -- after closing folds, keep the *current* fold open
  end
end, vim.api.nvim_create_namespace 'auto_pause_folds')

-- TODO: Implement global with autocommands <10-06-23>
vim.keymap.set('n', '<leader>uw', function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = 'Toggle wrap' })
-- vim.keymap.set('n', '<leader>uW', function()
--   vim.opt.wrap = not vim.opt.wrap:get()
-- end, { desc = 'Toggle wrap global' })
vim.keymap.set('n', '<leader>us', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = 'Toggle spell' })
-- vim.keymap.set('n', '<leader>uS', function()
--   vim.opt.spell = not vim.opt.spell:get()
-- end, { desc = 'Toggle spell global' })

local cursorPreYank
vim.keymap.set({ 'n', 'x' }, 'y', function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return 'y'
end, { expr = true })

vim.keymap.set('n', 'Y', function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return 'y$'
end, { expr = true, desc = 'yank to eol' }) -- Y to act as D and C

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and cursorPreYank then
      vim.api.nvim_win_set_cursor(0, cursorPreYank)
    end
  end,
})
