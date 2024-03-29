require('nvim-treesitter.configs').setup {
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
  highlight = { enable = true, disable = { 'latex', 'vim' } },
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
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
  },
  rainbow = {
    -- TODO: This plugin not functioning correctly at the moment. When fixed enable. <23-02-22, kunzaatko> --
    enable = true,
    disable = { 'lua', 'rust' },
    extended_mode = false,
    -- TODO: Edit colours. Use desaturated coulours from lush.nvim <20-02-22, kunzaatko> --
    colors = {
      '#bf616a',
      '#d08770',
      '#ebcb8b',
      '#a3be8c',
      '#b48ead',
    },
  },
}
