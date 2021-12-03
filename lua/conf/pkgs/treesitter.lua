require('nvim-treesitter.configs').setup {
  highlight = {enable = true},
  indent = {enable = true},
  refactor = {
    smart_rename = {enable = true, keymaps = {smart_rename = "<leader>tr"}},
    highlight_definitions = {enable = true},
  },
}
