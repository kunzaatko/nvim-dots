local o,ob,ow = vim.o,vim.ob,vim.ow -- global, buffer, window
local get_opt = vim.api.nvim_get_option

--[[ number and relative number together uses number on current line and
     relativenumber on the surrounding ]]
ow.relativenumber, ow.number = true, true

--[[ ignore case in search and substitute for all lower-case patterns but
     do not ignore case for patterns with an upper-case letter ]]
o.ignorecase, o.smartcase = true, true


-->> when missing end of line at end of screen replace *whole* line with @@@
o.display = 'truncate'

-->> brief jump to matching delimiter when inserted
o.showmatch = true

-->> use the mouse in visual and insert mode
o.mouse = 'vi'

--[[ Ex command <tab>-completion succession: common match string with wildmenu
     open, then first full match with wildmenu]]
o.wildmode = 'longest:full,full'

--[[ completeopt = insert mode completion: menu (even if only one option), do
     not insert until <tab>ed, do not select until <tab>ed
     shortmess = do not print messeges like "-- XXX completion (YYY)" ]]
o.completeopt = 'menuone,noinsert,noselect'
o.shortmess = get_opt('shortmess')..'c'

ow.scrolloff = 3

--[[ copy everything also to the system clipboard (not just while using "+ and
     "* registers) ]]
o.clipboard = get_opt('clipboard') == '' and 'unnamedplus' or
              'unnamedplus,'..get_opt('clipboard') -- create if == ''

--[[ persistent undo on close of the file (undolevel = 1000,
     undodir = "$XDG_DATA_HOME/nvim/undo/") ]]
ob.undofile = true

-->> preferred directions on window splitting
o.splitright, o.splitbelow = true, true

-->> remaps in normal mode (compensation for Czech keyboard locale)
o.langmap = 'ě2,š3,č4,ř5,ž6,ý7,á8,í9'
ow.spelllang = 'cs,en_gb'

--[[ expandtab - expand a tab into spaces,
     tabstop,shiftwidth - # of spaces for <tab> (tabstop) in insert and for
                          <<,>> in normal (shiftwidth)
     shiftround - round to nearest multiple of shiftwidth ]]
local indent = 4
ob.expandtab = true
ob.tabstop, ob.shiftwidth = indent,indent
o.shiftround = true

for _,x in ipairs({table.unpack(ob)}) do table.insert(o,x) end
for _,x in ipairs({table.unpack(ow)}) do table.insert(o,x) end
