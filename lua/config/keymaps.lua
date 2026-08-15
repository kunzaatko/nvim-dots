local which_key_exists, wk = pcall(require, 'which-key')

if which_key_exists then
  -- TODO: Add other groups <03-05-23>
  -- TODO: Do not list window mappings after leader <20-05-23>
  wk.add {
    { '<leader>a', group = string.format('%s %s', static.icons.ai, 'AI') },
    { '<leader>f', group = string.format('%s %s', static.icons.find, 'Find') },
    { '<leader>g', group = string.format('%s %s', static.icons.git.git, 'Git') },
    { '<leader>s', group = string.format('%s %s', static.icons.snippets, 'Snippets') },
    { '<leader>t', group = string.format('%s %s', static.icons.terminal, 'Terminal') },
  }
end

-- Command line shortcuts
vim.keymap.set('n', '<leader>w', vim.cmd.update, { silent = false, desc = 'write buffer if modified' })
vim.keymap.set('n', '<leader>q', vim.cmd.quit, { silent = false, desc = 'quit window' })
vim.keymap.set('n', '<leader>Q', vim.cmd.xit, { silent = false, desc = 'write and quit' })
vim.keymap.set({ 'n', 'v' }, '<Space>', ':', { desc = 'command line' })

-- View manipulation
vim.keymap.set('n', '|', vim.cmd.vsplit, { desc = 'split vertical' })
vim.keymap.set('n', '\\', vim.cmd.split, { desc = 'split horizontal' })
vim.keymap.set('n', ']t', vim.cmd.tabnext, { desc = 'next tab' })
vim.keymap.set('n', '[t', vim.cmd.tabprevious, { desc = 'previous tab' })

-- Text Objects
vim.keymap.set({ 'o', 'x' }, 'ae', require('util.visual').entire_buffer, { desc = 'entire buffer textobj' })
vim.keymap.set({ 'o', 'x' }, 'ie', require('util.visual').entire_buffer, { desc = 'entire buffer textobj' })
--
local append_blank_lines = function()
  vim.fn.append(vim.api.nvim_win_get_cursor(0)[1], vim.fn['repeat']({ '' }, vim.api.nvim_get_vvar 'count1'))
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufReadPost' }, {
  group = vim.api.nvim_create_augroup('modifying keymaps', {}),
  desc = 'Create keymaps that are applicable only to modifiable buffers',
  callback = function()
    if vim.opt.modifiable:get() then
      if not vim.tbl_contains({ 'oil', 'qf' }, vim.opt.filetype:get()) then
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

-- TODO: I would like for the file if already open to change to that window instead (with `gF`) with the line-number of
-- the requested file. I would like to change the opening behaviour in some buffer types to launch in the alternate
-- window (e.g. in `opencode` and the terminal to launch in the window other than the one that holds `opencode`).
-- <17-03-2026>
-- TODO: Could this be handled by `'includeexpr'` or `'path'` options instead? <17-03-2026>
--- When the file under the cursor does not exist a prompt is given to create it and optionally is created
vim.keymap.set('n', 'gf', function()
  local cursor_file = vim.fn.expand '<cfile>'
  local current_buffer_path = vim.api.nvim_buf_get_name(0)
  local target_path

  if current_buffer_path == '' then -- [NO NAME] buffers
    target_path = vim.fn.fnamemodify(cursor_file, ':p')
  else
    local current_buffer_dir = vim.fn.fnamemodify(current_buffer_path, ':h') -- e.g., /home/user/project/src
    target_path = vim.fn.fnamemodify(vim.fs.joinpath(current_buffer_dir, cursor_file), ':p')
  end

  if vim.fn.filereadable(target_path) == 1 then
    return 'gf' -- default behaviour
  else
    vim.notify('`gf`: `' .. vim.fn.pathshorten(target_path) .. '` does not exist', vim.log.levels.WARN)
    vim.schedule(function()
      vim.ui.select({ 'yes', 'no' }, { prompt = 'Should the file `' .. target_path .. '` be created?' }, function(i)
        if i == 'yes' then
          vim.cmd('edit ' .. vim.fn.fnameescape(target_path)) -- filename escaped for special characters
          vim.notify('`gf`: created file `' .. vim.fn.pathshorten(target_path) .. '`', vim.log.levels.INFO)
        end
      end)
    end)
  end
  return '' -- handled in the callback from scheduled `vim.ui.select`
end, { expr = true })

-- UI

vim.keymap.set('n', '<space><space>', '<cmd>e #<CR>', { desc = 'open alternate-file' })

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

  local pauseFold = vim.wo.foldenable and searchKeyUsed
  local unpauseFold = not vim.wo.foldenable and not searchKeyUsed
  if pauseFold then
    vim.opt.foldenable = false
  elseif unpauseFold then
    vim.opt.foldenable = true
    vim.cmd.normal 'zv' -- after closing folds, keep the *current* fold open
  end
end, vim.api.nvim_create_namespace 'auto_pause_folds')

-- When yanking line-wise, restore the cursor position --
local cursorPreYank
vim.keymap.set({ 'n', 'x' }, 'y', function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return 'y'
end, { expr = true })

-- HACK: Default `Y` mapping does not work with `TextYankPost` <28-07-25>
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
