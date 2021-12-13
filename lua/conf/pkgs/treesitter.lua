local parser_configs = require'nvim-treesitter.parsers'.get_parser_configs()

parser_configs.norg = {
  install_info = {
    url = 'https://github.com/nvim-neorg/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main',
  },
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'css',
    'fish',
    'go',
    'html',
    'json',
    'julia',
    'latex',
    'lua',
    'norg',
    'python',
    'query',
    'rust',
    'toml',
    'vim',
    'yaml',
  },
  highlight = { enable = true },
  indent = { enable = true },
  playground = {
    enable = true,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
