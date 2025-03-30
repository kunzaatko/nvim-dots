local M = {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  event = { 'InsertEnter', 'VeryLazy' },
  build = 'make install_jsregexp',
}

function M.config()
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
      require('blink.cmp').is_visible()
      and require('blink.cmp.completion.list').selected_item_idx ~= nil
      and (
        require('blink.cmp.completion.list').get_selected_item().source_id == 'luasnip'
        -- TODO: Is it true that for all the sources the snippet type is 15? This needs to be checked. <14-12-24> 
        or require('blink.cmp.completion.list').get_selected_item().kind == 15 -- kind==15 is a lsp snippet
      )
    then
      require('blink.cmp').accept()
    elseif
      require('blink.cmp').is_visible() and require('blink.cmp.completion.list').items[1].source_id == 'luasnip'
    then
      require('blink.cmp').accept { index = 1 }
    end
  end, { silent = true, desc = 'jump forward or expand snippet' })

  -- FIX: Consider mapping ALT instead of CTRL modifier same a Neocodeium. It is more ergonomic and closer for the
  -- fingers. <30-03-25>
  vim.keymap.set({ 'i', 's' }, '<C-h>', function()
    if ls.locally_jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true, desc = 'jump backward in snippet' })
  vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    else
      require('blink.cmp').select_prev()
    end
  end, { silent = true, desc = 'choose next ChoiceNode' })
  vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if ls.choice_active() then
      ls.change_choice(-1)
    else
      require('blink.cmp').select_next()
    end
  end, { silent = true, desc = 'choose prev ChoiceNode' })
end

return M
