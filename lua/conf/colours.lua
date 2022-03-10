local cmd = vim.cmd

-- TODO: On v0.7 change to lua API autocommand <10-03-22, kunzaatko> --
-- highlight yanked text
--luacheck: no max line length
cmd [[
    augroup HighlightYank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", timeout=300, on_visual=true, on_macro=false}
    augroup END
]]
--luacheck: max line length 120
-- fold marker highlighting
cmd 'highlight default link FoldMarker vimHiClear'
