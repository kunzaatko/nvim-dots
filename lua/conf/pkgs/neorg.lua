require('neorg').setup {
  load = {
    ['core.defaults'] = {},
    ['core.norg.concealer'] = {},
    ['core.norg.dirman'] = {
      config = {
        workspaces = {
          thesis = '~/University/ČVUT/Thesis/documents/notes/',
          global = '~/notes/',
          school = '~/University/ČVUT/notes/',
        },
      },
    },
    ['core.norg.completion'] = { config = { engine = 'nvim-cmp' } },
    ['core.gtd.base'] = {},
  },

  hook = function()
    local neorg_callbacks = require 'neorg.callbacks'

    neorg_callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
      keybinds.map_event_to_mode('norg', {
        n = {
          { '<leader>ntd', 'core.norg.qol.todo_items.todo.task_done' },
          { '<leader>ntu', 'core.norg.qol.todo_items.todo.task_undone' },
          { '<leader>ntp', 'core.norg.qol.todo_items.todo.task_pending' },
          { '<C-Space>', 'core.norg.qol.todo_items.todo.task_cycle' },
        },
      }, { silent = true, noremap = true })
    end)
  end,
}
