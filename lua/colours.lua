local autocmd = require'utils'.autocmd
autocmd('','TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", timeout=300, on_visual=false, on_macro=false}')
