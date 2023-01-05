local M = {
  -- TODO: Make Julia persistent REPL implementation <16-01-22, kunzaatko> --
  -- akinsho/toggleterm.nvim -- toggle the terminal but persist the session{{{
  {
    'akinsho/toggleterm.nvim',
    as = 'toggleterm',
    config = function()
      local wk = require 'which-key'
      wk.register({
        ['<C-p>'] = { 'Toggle toggleterm' },
      }, {})

      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'term://*',
        group = vim.api.nvim_create_augroup('ToggleTerm', {}),
        desc = 'Terminal environment setup',
        callback = function()
          vim.opt_local.spell = false
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-W><C-W>]], { buffer = 0, desc = 'exit terminal window' })
        end,
      })

      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = '<C-p>',
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 1, -- darken terminal colour degree, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = 'vertical',
        close_on_exit = true, -- close the terminal window when the process exits
        shell = 'fish',
      }
    end,
  },
  -- }}}
}

return M
