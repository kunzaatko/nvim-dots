local get_opt = vim.api.nvim_get_option

--[[ number and relative number together uses number on current line and
     relativenumber on the surrounding ]]
vim.wo.relativenumber = true
vim.wo.number = true

--[[ ignore case in search and substitute for all lower-case patterns but
     do not ignore case for patterns with an upper-case letter ]]
vim.o.ignorecase = true
vim.o.smartcase = true

-- >> when missing end of line at end of screen replace *whole* line with @@@
vim.o.display = 'truncate'

-- >> brief jump to matching delimiter when inserted
vim.o.showmatch = true

-- >> use the mouse in visual and insert mode
vim.o.mouse = 'a'

-- >> which shell to use in the terminal
vim.o.shell = 'fish'

--[[ Ex command <tab>-completion succession: common match string with wildmenu
     open, then first full match with wildmenu]]
vim.o.wildmode = 'longest:full,full'

--[[ completeopt = insert mode completion: menu (even if only one option), do
     not insert until <tab>ed, do not select until <tab>ed
     shortmess = do not print messeges like "-- ZZZ completion (YYY)" ]]
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = get_opt('shortmess') .. 'c'

-- >> Do not show the mode in the command line
vim.o.showmode = false

--[[ scrolloff = minimum lines of context on the screen
     sidescrolloff = minimum columns of context on the screen ]]
vim.wo.scrolloff = 3
vim.wo.sidescrolloff = 5

-- >> do not split words on wrapping
vim.wo.linebreak = true

--[[ copy everything also to the system clipboard (not just while using "+ and
     "* registers) ]]
vim.o.clipboard = get_opt('clipboard') == '' and 'unnamedplus' or 'unnamedplus' .. get_opt('clipboard') -- create if not yet defined

--[[ persistent undo on close of the file (undolevel = 1000,
     undodir = "$XDG_DATA_HOME/nvim/undo/") without a swapfile ]]
vim.bo.undofile = true
vim.bo.swapfile = false

-- >> preferred directions on window splitting
vim.o.splitright = true
vim.o.splitbelow = true

-- >> remaps in normal mode (compensation for Czech keyboard locale)
vim.o.langmap = 'ě2,š3,č4,ř5,ž6,ý7,á8,í9'
vim.bo.spelllang = 'cs,en_gb'

--[[ expandtab = expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround = round to nearest multiple of shiftwidth ]]
local indent = 4
vim.bo.expandtab = true
vim.bo.tabstop = indent
vim.bo.shiftwidth = indent
vim.o.shiftround = true

-- >> fold boundaries determined by markers {{{ and }}}
vim.wo.foldmethod = 'marker'

-- >> do not insert a comment string after hitting <CR> in insert mode
vim.bo.formatoptions = get_opt('formatoptions'):gsub('.', {o = ''}) -- TODO: test if works <06-03-21, kunzaatko> --

-- >> use truecolours in colorschemes (this can brake colorschemes if they are not built for it)
vim.o.termguicolors = true
