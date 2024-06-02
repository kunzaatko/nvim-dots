vim.opt.number = true -- line numbers
vim.opt.infercase = true -- infer the case for insert mode completion
vim.opt.ignorecase, vim.opt.smartcase = true, true -- case insensitive for searching
vim.opt.showmatch = true -- matching delimiter jump
vim.opt.mouse = 'a' -- all mouse modes
vim.opt.shell = 'dash' -- shell for execution ('dash' for performance)

vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' } -- insert mode completion strategy
vim.opt.backspace:append { 'nostop' } -- Don't stop backspace at insert
vim.opt.diffopt:append 'algorithm:patience,linematch:60'

vim.opt.shortmess:append { c = true, I = true } -- do not show ins-completion-menu messages

-- vim.opt.virtualedit = 'block' -- allow going past end of line in visual block mode
vim.opt.pumheight = 15 -- max number of popup menu items
vim.opt.showmode = false -- do not show mode on last line
vim.opt.scrolloff = 2 -- leave 2 lines above/below while vertical scrolling
vim.opt.sidescrolloff = 4 -- leave 4 chars after/before while horizontal scrolling
vim.opt.clipboard:prepend 'unnamedplus' -- use system clipboard
vim.opt.undofile = true -- persistent undo history
vim.opt.swapfile = false -- do not save a swapfile
vim.opt.backup = true -- backup file when overwriting
if vim.env.XDG_STATE_HOME then
  vim.opt.backupdir = vim.env.XDG_STATE_HOME .. '/nvim/backup//'
else
  vim.opt.backupdir = './.backup//'
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
      vim.notify(
        '`$XDG_STATE_HOME` is not set. The backup will be written in `' .. vim.api.nvim_get_option 'backupdir' .. '`',
        vim.log.levels.WARN,
        { title = '`backupdir`' }
      )
    end,
    desc = 'Warning about the `backupdir` `ENV` variable not set',
    once = true,
  })
end
vim.opt.splitbelow, vim.opt.splitright = true, true -- positions of new splits
vim.opt.startofline = true -- some commands move the cursor to the start of line
vim.opt.langmap = { 'ě2', 'š3', 'č4', 'ř5', 'ž6', 'ý7', 'á8', 'í9' } -- number remaps in normal mode

vim.opt.splitkeep = 'topline' -- when horizontal splitting, keep top screen line in place

vim.opt.spell = true
vim.opt.spelllang = { 'cs', 'en_gb' }
vim.opt.spellfile = {
  vim.fn.stdpath 'config' .. '/spell/cs.utf-8.add',
  vim.fn.stdpath 'config' .. '/spell/en.utf-8.add',
  vim.fn.stdpath 'config' .. '/spell/prog.utf-8.add',
}
vim.opt.spelloptions = 'camel' -- accept CamelCased spelling

vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftround = true -- round the indents
vim.opt.smartindent = true -- new line indenting
vim.opt.breakindent = true -- preserve visual indentation when wrapping
vim.opt.smarttab = true -- deleting whole tab at once

-- NOTE: Default values. Are determined by plugin `guess-indent`
vim.opt.tabstop, vim.opt.shiftwidth = 4, 4

vim.opt.formatoptions:append 'n1' -- do not wrap after 1 letter words and numbered list comprehension
vim.opt.textwidth = 120
vim.opt.colorcolumn = { vim.opt.textwidth:get() + 1 }
vim.opt.termguicolors = true -- 24-bit colours
-- vim.opt.guicursor = -- cursor styles for modes
--   'n-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,v:block-blinkwait175-blinkoff150-blinkon175,ve:ver25-blinkwait175-blinkoff150-blinkon175'
-- TODO: https://github.com/neovim/neovim/issues/3681
vim.opt.guicursor = {
  'n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'i-ci-o:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100',
}

vim.opt.cursorline, vim.opt.cursorlineopt = true, 'number' -- highlight cursorline
vim.opt.foldcolumn = '0' -- style of fold column
vim.opt.foldlevel = 6 -- show six levels when opening a file
vim.opt.foldmethod = 'manual'
-- TODO: Test only showing sign column on active window <05-01-23>
vim.opt.signcolumn = 'auto:4' -- style of sign column

if vim.fn.executable 'rg' == 1 then
  vim.opt.grepprg = 'rg --no-heading --vimgrep' -- use rg instead of `grep`
  vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.opt.list = true -- show invisible characters
vim.opt.listchars = { eol = '↩', tab = '▸ ', trail = '·', nbsp = '·' }

vim.opt.fillchars = {
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
  diff = '🮮',
  fold = '┉',
  -- foldopen = '▾',
  -- foldsep = '┊',
  -- foldclose = '▸',
  vert = '┃',
  horizup = '┻',
  horizdown = '┳',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
  horiz = '━',
}
vim.opt.laststatus = 3 -- single status line
-- vim.opt.cmdheight = 0 -- no cmdline when it is not in use
