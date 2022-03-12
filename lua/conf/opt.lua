local opt = vim.opt

--[[ number and relative number together uses number on current line and
     relativenumber on the all other lines -> useful for jumps and macros]]
opt.number, opt.relativenumber = true, true

--[[ ignore case in search and substitute for all lower-case patterns but
     do not ignore case for patterns with an upper-case letter ]]
opt.ignorecase, opt.smartcase = true, true

-->> when missing end of line at end of screen replace *whole* line with @@@
opt.display = 'truncate'

-->> brief jump to matching delimiter when inserted
opt.showmatch = true

-->> use the mouse in visual and insert mode
opt.mouse = 'a'

-->> which shell to use in the terminal
-- PERF: Using fish may cause the plugins that execute shell commands act slower than with using `sh`
-- or `dash` (which is even faster)--
-- NOTE: some ENV variables will maybe have to be set in dash, which are now reliant on fish startup <kunzaatko> --
opt.shell = 'dash'

--[[ Ex command <tab>-completion succession: common match string with wildmenu
     open, then first full match with wildmenu]]
opt.wildmode = { longest = 'full', 'full' }

--[[ completeopt = insert mode completion: menu (even if only one option), do
     not insert until tabbed, do not select until tabbed
     shortmess = do not print messages like "-- ZZZ completion (YYY)" ]]
opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
opt.shortmess:append 'c'

-->> Maximum menu height
opt.pumheight = 15

-->> Do not show the mode in the command line
opt.showmode = false

--[[ scrolloff = minimum lines of context on the screen
     sidescrolloff = minimum columns of context on the screen ]]
opt.scrolloff = 3
opt.sidescrolloff = 5

-->> do not split words on wrapping
opt.linebreak = true

--[[ copy everything also to the system clipboard (not just while using "+ and
     "* registers) ]]
opt.clipboard:prepend 'unnamedplus'

--[[ persistent undo on close of the file (undolevel = 1000,
     undodir = "$XDG_DATA_HOME/nvim/undo/") without a swapfile ]]
opt.undofile = true
opt.swapfile = false

-->> Save window positions and terminal in shada file
opt.sessionoptions:append 'winpos,terminal'

-->> preferred directions on window splitting
opt.splitbelow, opt.splitright = true, true

-->> remaps in normal mode (compensation for Czech keyboard locale)
opt.langmap = { 'ě2', 'š3', 'č4', 'ř5', 'ž6', 'ý7', 'á8', 'í9' }

-->> spelling languages and spell off. Camel indicates that in CamelCased  words,
-- the upper letter is used as space delimiter.
opt.spell = false
opt.spelllang = { 'cs', 'en_gb' }
opt.spelloptions = 'camel'

--[[ expandtab = expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround = round to nearest multiple of shiftwidth ]]
local indent = 4
opt.expandtab, opt.shiftround = true, true
opt.tabstop, opt.shiftwidth = indent, indent

-->> fold boundaries determined by markers {{{ and }}}
opt.foldmethod = 'marker'

-->> do not insert a comment string after hitting <CR> in insert mode
opt.formatoptions:remove 'o'

-->> maximum text width to adhere to
opt.textwidth = 100

-->> use truecolours in colour-schemes (this can brake colour-schemes if they are not built for it)
opt.termguicolors = true
opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-->> use cursorline but only highlight the number
opt.cursorline = true
opt.cursorlineopt = 'number'

-->> see the number of folds in the columns to the left and + - signs
opt.foldcolumn = 'auto:4'

-->> see the signcolumn always and not just on diagnostics or when there is a gitsign
opt.signcolumn = 'auto:1-9'

-->> set rg as the back-end for :grep command
if vim.fn.executable 'rg' == 1 then
  opt.grepprg = 'rg --no-heading --vimgrep'
  opt.grepformat = '%f:%l:%c:%m'
end

-->> show hidden characters
opt.list = true
opt.listchars = { eol = '↩', tab = '▸ ', trail = '·' }
opt.fillchars = { diff = '░', fold = '┉', foldopen = '▾', foldsep = '┊', foldclose = '▸', vert = '┃' }
