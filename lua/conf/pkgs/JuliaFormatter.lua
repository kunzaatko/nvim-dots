local map = require'utils'.map

vim.g.JuliaFormatter_options = {["style"] = "blue"}

-- Mapping
map('n', '<leader>f', '<Cmd>JuliaFormatterFormat<CR>', {silent = true})
