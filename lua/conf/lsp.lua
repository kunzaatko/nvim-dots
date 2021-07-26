local cmd = vim.cmd

-- Used for swapfiles and the CursorHold event (autocommands for the LSP)
vim.opt.updatetime = 300

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
               {virtual_text = false, signs = true, update_in_insert = true})

cmd [[
    augroup ShowDiagnosticsPopup
        autocmd!
        autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
    augroup END
]] -- Show diagnostic popup on CursorHold