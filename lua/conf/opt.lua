local opt = require'utils'.opt
local get_opt = vim.api.nvim_get_option
local window, buffer = {vim.o, vim.wo}, {vim.o, vim.bo} -- scopes

--[[ number and relative number together uses number on current line and
     relativenumber on the surrounding ]]
opt('relativenumber', true, window)
opt('number', true, window)

--[[ ignore case in search and substitute for all lower-case patterns but
     do not ignore case for patterns with an upper-case letter ]]
opt('ignorecase', true)
opt('smartcase', true)

-- >> when missing end of line at end of screen replace *whole* line with @@@
opt('display', 'truncate')

-- >> brief jump to matching delimiter when inserted
opt('showmatch', true)

-- >> use the mouse in visual and insert mode
opt('mouse', 'a')

--[[ Ex command <tab>-completion succession: common match string with wildmenu
     open, then first full match with wildmenu]]
opt('wildmode', 'longest:full,full')

--[[ completeopt = insert mode completion: menu (even if only one option), do
     not insert until <tab>ed, do not select until <tab>ed
     shortmess = do not print messeges like "-- ZZZ completion (YYY)" ]]
opt('completeopt', 'menuone,noinsert,noselect')
opt('shortmess', get_opt('shortmess') .. 'c')

-- >> Do not show the mode in the command line
opt('showmode', false)

--[[ scrolloff = minimum lines of context on the screen
     sidescrolloff = minimum columns of context on the screen ]]
opt('scrolloff', 3, window)
opt('sidescrolloff', 5, window)

-- >> do not split words on wrapping
opt('linebreak', true, window)

--[[ copy everything also to the system clipboard (not just while using "+ and
     "* registers) ]]
opt('clipboard', get_opt('clipboard') == '' and 'unnamedplus' or 'unnamedplus' ..
      get_opt('clipboard')) -- create if not yet defined

--[[ persistent undo on close of the file (undolevel = 1000,
     undodir = "$XDG_DATA_HOME/nvim/undo/") without a swapfile ]]
opt('undofile', true, buffer)
opt('swapfile', false, buffer)

-- >> preferred directions on window splitting
opt('splitright', true)
opt('splitbelow', true)

-- >> remaps in normal mode (compensation for Czech keyboard locale)
opt('langmap', 'ě2,š3,č4,ř5,ž6,ý7,á8,í9')
opt('spelllang', 'cs,en_gb', buffer)

--[[ expandtab = expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround = round to nearest multiple of shiftwidth ]]
local indent = 4
opt('expandtab', true, buffer)
opt('tabstop', indent, buffer)
opt('shiftwidth', indent, buffer)
opt('shiftround', true)

-- >> do not insert a comment string after hitting <CR> in insert mode
opt('formatoptions', get_opt('formatoptions'):gsub('.', {o = ''}), buffer) -- TODO: test if works <06-03-21, kunzaatko> --

-- >> use truecolours in colorschemes (this can brake colorschemes if they are not built for it)
opt('termguicolors', true)
