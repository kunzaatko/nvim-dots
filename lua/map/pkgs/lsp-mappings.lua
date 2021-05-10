local map = vim.api.nvim_buf_set_keymap

map(0, 'n', '<C-]>', "<Cmd>lua vim.lsp.but.definition()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
map(0, 'n', 'gD', "<Cmd>lua vim.lsp.buf.implementation()<CR>",
    {noremap = true, silent = true})
map(0, 'n', '<C-k>', "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
    {noremap = true, silent = true})
map(0, 'n', '1gD', "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'gr', "<Cmd>lua vim.lsp.buf.references()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'g0', "<Cmd>lua vim.lsp.buf.document_symbol()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'gW', "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'gd', "<Cmd>lua vim.lsp.buf.declaration()<CR>",
    {noremap = true, silent = true})
map(0, 'n', 'ga', "<Cmd>lua vim.lsp.buf.code_action()<CR>",
    {noremap = true, silent = true})
