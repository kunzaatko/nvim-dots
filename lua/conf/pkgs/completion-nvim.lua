local autocmd= require'utils'.autocmd

autocmd('completion-attach', [[BufEnter * lua require'completion'.on_attach()]]) -- autocommands that need to be run for completion
vim.g.completion_enable_snippet = 'UltiSnips'

autocmd('CompletionTriggerCharacter', {
  [[BufEnter * lua vim.g.completion_trigger_character = {'.'}]],
  [[BufEnter *.c,*.cpp,*.rust lua vim.g.completion_trigger_character = {'.', '::'}]],
})

vim.g.completion_chain_complete_list = {
  rust = {
    string = {
      {complete_items = {'path'}, triggered_only = {'/'}},
      {mode = '<c-p>'},
      {mode = '<c-n>'},
      {mode = '<incl>'},
      {mode = '<dict>'},
      {mode = '<thes>'},
      {mode = '<user>'},
    },
    func = {{complete_items = {'lsp', 'path', 'snippet'}}},
    default = {
      {complete_items = {'lsp', 'snippet'}},
      {mode = '<c-p>'},
      {mode = '<c-n>'},
    },
  },
  default = {
    default = {
      {complete_items = {'lsp', 'snippet'}},
      {complete_items = {'path'}, triggered_only = {'/'}},
      {mode = '<c-p>'},
      {mode = '<c-n>'},
    },
    comment = {
      {complete_items = {'path'}, triggered_only = {'/'}},
      {mode = '<c-p>'},
      {mode = '<c-n>'},
      {mode = '<incl>'},
      {mode = '<dict>'},
      {mode = '<thes>'},
      {mode = '<user>'},
    },
  },
}

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
