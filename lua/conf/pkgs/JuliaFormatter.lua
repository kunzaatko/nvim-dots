local map = vim.api.nvim_set_keymap

vim.g.JuliaFormatter_options = {["style"] = "blue"}

-- Mapping
map('n', '<leader>f', '<Cmd>JuliaFormatterFormat<CR>', {silent = true})
