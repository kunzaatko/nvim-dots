vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=150, on_visual=false, on_macro=false}'
