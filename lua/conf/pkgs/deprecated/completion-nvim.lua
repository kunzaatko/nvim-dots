local cmd = vim.cmd

-- autocommands --

cmd [[
    augroup CompletionAttach
        autocmd!
        autocmd BufEnter * lua require'completion'.on_attach()
    augroup END
]] -- autocommands that need to be run for completion

cmd [[
    augroup CompletionTriggerCharacter
        autocmd!
        autocmd BufEnter *.c,*.cpp,*.rs lua vim.g.completion_trigger_character = {'.','::'}
    augroup END
]] -- for method completions for different language syntax

-- options --

vim.g.completion_enable_snippet = 'UltiSnips'

vim.g.completion_popup_border = 'rounded' -- 'single', 'double', 'rounded', 'solid' and 'shadow'
vim.g.completion_enable_auto_paren = 1

vim.g.completion_chain_complete_list = {
  default = {
    default = {
      { complete_items = { 'lsp', 'snippet' } },
      { complete_items = { 'path' }, triggered_only = { '/' } },
      { mode = '<c-p>' },
      { mode = '<c-n>' },
    },
    comment = {
      { complete_items = { 'lsp', 'path' }, triggered_only = { '/' } },
      { mode = '<c-p>' },
      { mode = '<c-n>' },
      { mode = '<incl>' },
      { mode = '<dict>' },
      { mode = '<thes>' },
      { mode = '<user>' },
    },
  },

  rust = {
    default = {
      { complete_items = { 'lsp', 'snippet' } },
      { mode = '<c-p>' },
      { mode = '<c-n>' },
    },
    func = { { complete_items = { 'lsp', 'path', 'snippet' } } },
    comment = {
      { complete_items = { 'lsp', 'path' }, triggered_only = { '/' } },
      { mode = '<c-p>' },
      { mode = '<c-n>' },
      { mode = '<incl>' },
      { mode = '<dict>' },
      { mode = '<thes>' },
      { mode = '<user>' },
    },
    string = {
      { complete_items = { 'path' }, triggered_only = { '/' } },
      { mode = '<c-p>' },
      { mode = '<c-n>' },
      { mode = '<incl>' },
      { mode = '<dict>' },
      { mode = '<thes>' },
      { mode = '<user>' },
    },
  },
}

vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }

--  mappings  --

local map = vim.api.nvim_set_keymap

map('i', '<tab>', '<Plug>(completion_smart_tab)', {})
map('i', '<s-tab>', '<Plug>(completion_smart_s_tab)', {})

vim.g.completion_confirm_key = ""

_G.MUtils.completion_confirm = function()
  local npairs = require 'nvim-autopairs'
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.confirmCompletion()
      return npairs.esc("<c-y>")
    else
      vim.api.nvim_select_popupmenu_item(0, false, false, {})
      require'completion'.confirmCompletion()
      return npairs.esc("<c-n><c-y>")
    end
  else
    return npairs.check_break_line_char()
  end
end
map('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })

_G.MUtils.smart_pum_snip_fwd = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.smart_tab()
    else
      vim.call "UltiSnips#JumpForwards()"
    end
  else
    vim.call "UltiSnips#JumpForwards()"
  end
end

_G.MUtils.smart_pum_snip_bwd = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      require'completion'.smart_tab()
    else
      vim.call "UltiSnips#JumpBackwards()"
    end
  else
    vim.call "UltiSnips#JumpForwards()"
  end
end

-- TODO: Why dont these work? <07-03-21, kunzaatko> --
--[[ map('i' , '<c-j>','v:lua.MUtils.smart_pum_snip_fwd()', {expr = true , noremap = true})
map('i' , '<c-k>','v:lua.MUtils.smart_pum_snip_bwd()', {expr = true , noremap = true}) ]]

-- these mappings XXX work like this:
--                  if pum is visible:
--                     if something is selected:
--                          <Plug>...
--                     else:
--                          hide pum
--                          XXX

map(
  'i', '<c-j>',
  [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_smart_tab)" : "\<c-e>\<c-j>" : "\<c-j>"]],
  { expr = true }
)
map(
  'i', '<c-k>',
  [[pumvisible() ? complete_info()["selected"] != "-1" ? "\<Plug>(completion_smart_s_tab)" : "\<c-e>\<c-k>" : "\<c-k>"]],
  { expr = true }
)
