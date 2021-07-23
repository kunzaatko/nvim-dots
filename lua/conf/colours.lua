local cmd = vim.cmd

-- highlight yanked text
cmd [[
    augroup HighlightYank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", timeout=300, on_visual=false, on_macro=false}
    augroup END
]]
-- fold marker highlighting
cmd 'highlight default link FoldMarker vimHiClear'
