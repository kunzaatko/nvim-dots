local cmd = vim.cmd
_G.AUtils = {}
local AUtils = _G.AUtils

cmd [[
    augroup VimStartup
        autocmd!
        autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
    augroup END
]] -- restore cursor position (" -- mark of last cursor position)

cmd [[
    augroup FoldMarker
        autocmd!
        autocmd Syntax * syntax match FoldMarkerStart /\v(# ?|" ?|\/\* ?|\/\/ ?|; ?)?\{\{\{/ conceal cchar=⯈
        autocmd Syntax * syntax match FoldMarkerStop  /\v(# ?|" ?|\/\/ ?|; ?)?\}\}\}( ?\*\/)?/ conceal cchar=$
        autocmd Syntax * syntax cluster FoldMarker contains=FoldMarkerStart,FoldMarkerStop
        autocmd Syntax * syntax cluster cCommentGroup add=@FoldMarker
        autocmd Syntax * syntax cluster shCommentGroup add=@FoldMarker
        autocmd Syntax * syntax cluster vimCommentGroup add=@FoldMarker
    augroup END
]] -- setting the concealment of the foldmarker

-- TODO: Fix to include better logic when available in neovim lua <24-02-21, kunzaatko> --
cmd [[
    augroup NumberToggle
        autocmd!
        autocmd WinEnter,FocusGained,InsertLeave * lua if vim.wo.number == true then vim.wo.relativenumber = true end
        autocmd WinLeave,FocusLost,InsertEnter * lua if vim.wo.number == true then vim.wo.relativenumber = false end
    augroup END
]] -- turn off relative numbering when leaving the buffer

-- trim white-space after leaving the buffer
AUtils.trim_white_space = function()
  if vim.b.noTrimWhiteSpace then
    return
  end
  vim.cmd "%s/\\s\\+$//e"
end

cmd [[
    augroup TrimWhiteSpace
        autocmd!
        autocmd FileType snippet,matlab lua vim.b.noTrimWhiteSpace = true
        autocmd BufWritePre * call v:lua.AUtils.trim_white_space()
    augroup END
]]

cmd [[
        autocmd!
    augroup END
]]
