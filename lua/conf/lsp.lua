local cmd = vim.cmd

-- Used for swapfiles and the CursorHold event (autocommands for the LSP)
vim.opt.updatetime = 300

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
               {virtual_text = true, signs = true, update_in_insert = true})

cmd [[
    augroup ShowDiagnosticsPopup
        autocmd!
        autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
    augroup END
]] -- Show diagnostic popup on CursorHold

cmd [[
    augroup HoverWindowNumbering
        autocmd!
        autocmd BufEnter * lua if vim.o.filetype == "" then vim.opt.number, vim.opt.relativenumber = false,false end
        autocmd BufLeave * lua if vim.o.filetype == "" then vim.opt.number, vim.opt.relativenumber = true,true end
    augroup END
]] -- Do not number lines in popup hover window
