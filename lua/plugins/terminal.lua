local M = {
  {
    'akinsho/toggleterm.nvim',
    name = 'toggleterm',
    enabled = false,
    keys = { '<c-p>' },
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = '<c-p>',
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 1,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'vertical',
      close_on_exit = true,
      shell = 'fish',
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = 'term://*',
        group = vim.api.nvim_create_augroup('ToggleTerm', {}),
        desc = 'Terminal environment setup',
        callback = function()
          vim.opt_local.spell = false
          vim.keymap.set('t', '<c-w>', [[<c-\><c-n><c-w><c-w>]], { buffer = 0, desc = 'exit terminal window' })
        end,
      })
      require('toggleterm').setup(opts)
    end,
  },
  -- TODO: Cannot be the only window in the session <13-05-23>
  {
    'rebelot/terminal.nvim',
    opts = {
      cmd = 'fish',
      autoclose = true,
    },
    event = 'VeryLazy',
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'TermOpen' }, {
        group = vim.api.nvim_create_augroup('Terminal', {}),
        desc = 'Terminal environment setup',
        callback = function(args)
          if vim.startswith(vim.api.nvim_buf_get_name(args.buf), 'term://') then
            vim.opt_local.spell = false
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.winhl = 'Normal:NormalFloat'
            vim.cmd 'startinsert'
          end
        end,
      })
      require('terminal').setup(opts)

      local term_map = require 'terminal.mappings'
      local system_shell_term = require('terminal').terminal:new { autoclose = false }

      vim.keymap.set({ 'n', 't' }, 'ŧ', function()
        system_shell_term:toggle(nil, false)
      end, { desc = 'Toggle terminal' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ts', term_map.operator_send, { expr = true, desc = 'Sent to terminal' })
      vim.keymap.set('n', '<leader>to', term_map.toggle, { desc = 'Open terminal in split' })
      vim.keymap.set('n', '<leader>tO', term_map.toggle { open_cmd = 'enew' }, { desc = 'Open terminal in new buffer' })
      vim.keymap.set('n', '<leader>tk', term_map.kill, { desc = 'Kill terminal' })
      vim.keymap.set('n', '<leader>t]', term_map.cycle_next, { desc = 'Next terminal' })
      vim.keymap.set('n', '<leader>t[', term_map.cycle_prev, { desc = 'Previous terminal' })

      vim.keymap.set('t', '<C-n>', '<C-\\><C-n>', { desc = 'Change to normal mode' })
      vim.keymap.set('t', '<M-h>', '<cmd>wincmd h<cr>', { desc = 'Terminal left window navigation' })
      vim.keymap.set('t', '<M-j>', '<cmd>wincmd j<cr>', { desc = 'Terminal down window navigation' })
      vim.keymap.set('t', '<M-k>', '<cmd>wincmd k<cr>', { desc = 'Terminal up window navigation' })
      vim.keymap.set('t', '<M-l>', '<cmd>wincmd l<cr>', { desc = 'Terminal right window navigation' })
    end,
  },
  {
    'willothy/flatten.nvim',
    opts = {},
    tag = 'v0.3.0',
    lazy = false,
    priority = 1001,
  },
}

return M
