local M = {
  'L3MON4D3/LuaSnip',
  event = { 'InsertEnter', 'VeryLazy' },
  build = 'make install_jsregexp',
}

function M.config()
  local cmp = require 'cmp'
  local ls = require 'luasnip'
  local ft_functions = require 'luasnip.extras.filetype_functions'
  ls.config.setup {
    history = true,
    update_events = { 'TextChanged', 'TextChangedI' },
    region_check_events = 'CursorMoved',
    delete_check_events = 'TextChanged',
    enable_autosnippets = true,
    store_selection_keys = '<Tab>',
    ft_func = ft_functions.from_filetype,
    snip_env = {
      s = function(...)
        local snip = ls.s(...)
        table.insert(getfenv(2).ls_file_snippets, snip)
      end,
      utils = require 'util.snippets',
    },
    ext_opts = {
      [require('luasnip.util.types').insertNode] = {
        active = { virt_text = { { static.icons.snippets, 'DiagnosticVirtualTextWarn' } } },
        visited = { virt_text = { { static.icons.snippets, 'DiagnosticVirtualTextInfo' } } },
        passive = { virt_text = { { static.icons.snippets, 'DiagnosticVirtualTextHint' } } },
      },
      [require('luasnip.util.types').choiceNode] = {
        active = { virt_text = { { static.icons.snippets, 'DiagnosticVirtualTextWarn' } } },
        unvisited = { virt_text = { { static.icons.snippets, 'DiagnosticVirtualTextHint' } } },
      },
    },
  }
  require('luasnip.loaders.from_lua').lazy_load {
    paths = { './snippets' },
  }

  vim.keymap.set('n', '<leader>se', function()
    require('luasnip.loaders').edit_snippet_files()
  end, { desc = 'Edit snippets' })
  vim.keymap.set({ 'i', 's' }, '<C-l>', function()
    if ls.expand_or_locally_jumpable() then
      ls.expand_or_jump()
    elseif
      cmp.visible() and require('cmp.types').lsp.CompletionItemKind[cmp.get_entries()[1]:get_kind()] == 'Snippet'
    then
      cmp.confirm { select = true }
      -- ls.expand()
    end
  end, { silent = true, desc = 'jump forward or expand snippet' })
  vim.keymap.set({ 'i', 's' }, '<C-h>', function()
    if ls.locally_jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true, desc = 'jump backward in snippet' })
  vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true, desc = 'choose next ChoiceNode' })
  vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end, { silent = true, desc = 'choose prev ChoiceNode' })
end

return M
