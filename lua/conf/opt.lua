local get_opt = vim.api.nvim_get_option

--[[ number and relative number together uses number on current line and
     relativenumber on the surrounding ]]
vim.opt.number, vim.opt.relativenumber = true, true

--[[ ignore case in search and substitute for all lower-case patterns but
     do not ignore case for patterns with an upper-case letter ]]
vim.opt.ignorecase, vim.opt.smartcase = true, true

-- >> when missing end of line at end of screen replace *whole* line with @@@
vim.opt.display = 'truncate'

-- >> brief jump to matching delimiter when inserted
vim.opt.showmatch = true

-- >> use the mouse in visual and insert mode
vim.opt.mouse = 'a'

-- >> which shell to use in the terminal
vim.opt.shell = 'fish'

--[[ Ex command <tab>-completion succession: common match string with wildmenu
     open, then first full match with wildmenu]]
vim.opt.wildmode = 'longest:full,full'

--[[ completeopt = insert mode completion: menu (even if only one option), do
     not insert until <tab>ed, do not select until <tab>ed
     shortmess = do not print messeges like "-- ZZZ completion (YYY)" ]]
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.shortmess = get_opt('shortmess') .. 'c'

-- >> Do not show the mode in the command line
vim.opt.showmode = false

--[[ scrolloff = minimum lines of context on the screen
     sidescrolloff = minimum columns of context on the screen ]]
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5

-- >> do not split words on wrapping
vim.opt.linebreak = true

--[[ copy everything also to the system clipboard (not just while using "+ and
     "* registers) ]]
vim.opt.clipboard = get_opt('clipboard') == '' and 'unnamedplus' or 'unnamedplus' ..
                      get_opt('clipboard') -- create if not yet defined

--[[ persistent undo on close of the file (undolevel = 1000,
     undodir = "$XDG_DATA_HOME/nvim/undo/") without a swapfile ]]
vim.opt.undofile = true
vim.opt.swapfile = false

-- >> preferred directions on window splitting
vim.opt.splitbelow, vim.opt.splitright = true, true

-- >> remaps in normal mode (compensation for Czech keyboard locale)
vim.opt.langmap = 'ě2,š3,č4,ř5,ž6,ý7,á8,í9'
vim.opt.spelllang = 'cs,en_gb'

--[[ expandtab = expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround = round to nearest multiple of shiftwidth ]]
local indent = 4
vim.opt.expandtab, vim.opt.shiftround = true, true
vim.opt.tabstop, vim.opt.shiftwidth = indent, indent

-- >> fold boundaries determined by markers {{{ and }}}
vim.opt.foldmethod = 'marker'

-- >> do not insert a comment string after hitting <CR> in insert mode
vim.opt.formatoptions = get_opt('formatoptions'):gsub('.', {o = ''}) -- TODO: test if works <06-03-21, kunzaatko> --

-- >> use truecolours in colorschemes (this can brake colorschemes if they are not built for it)
vim.opt.termguicolors = true
vim.opt.guicursor =
  "n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

-- >> set rg as the backend for :grep command
if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = "rg --no-heading --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- >> show hidden characters
vim.opt.listchars = "nbsp:¬,extends:»,precedes:«,trail:•"
