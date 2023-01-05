local utils = require 'pkg.utils'
local M = {
  -- TODO: add mappings <12-03-22, kunzaatko> --
  -- TODO: change the cursor color on in snippet. Different for selectnodes and for insertnodes <13-03-22, kunzaatko> --
  -- 'L3MON4D3/LuaSnip' -- snippets written in lua {{{
  {
    'L3MON4D3/LuaSnip',
    -- event = 'InsertEnter',
    -- keys = utils.get_keys('n', '<leader><leader>s'),
    config = function()
      local map = vim.keymap.set
      local ls = require 'luasnip'
      local ft_functions = require 'luasnip.extras.filetype_functions'
      -- local types = require 'luasnip.util.types'
      ls.config.setup {
        history = false,
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
        store_selection_keys = '<Tab>',
        ft_func = ft_functions.from_filetype,
      }
      require 'snippets'

      map({ 'i', 's' }, '<C-l>', function()
        if ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true, desc = 'jump forward or expand snippet' })
      map({ 'i', 's' }, '<C-h>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = 'jump backward in snippet' })
      -- FIX: Only local choice (on the current snippet) should be considered <13-03-22, kunzaatko> --
      map({ 'i', 's' }, '<C-k>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = 'choose next ChoiceNode' })
      map({ 'i', 's' }, '<C-j>', function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = 'choose prev ChoiceNode' })
    end,
  },
  -- }}}

  -- TODO: Module documentation generation <16-01-22, kunzaatko> --
  -- 'danymat/neogen' -- generate documentation for functions based on treesitter {{{
  {
    'danymat/neogen',
    keys = utils.get_keys('n', { { '<leader>d' }, { 'd', 'c', 'f', 't' } }),
    setup = function()
      local wk = require 'which-key'
      wk.register({
        d = {
          name = 'DocGen',
          d = { 'Generate' },
          c = { 'Class' },
          f = { 'Function' },
          t = { 'Type' },
        },
      }, { prefix = '<leader>' })
    end,
    config = function()
      local map = vim.keymap.set
      require('neogen').setup { snippet_engine = 'luasnip' }
      -- TODO: Generate the adequate type of documentation based on the type in TS that the cursor
      -- is on <28-08-22, kunzaatko>
      -- NOTE: The `{ type = 'func' }` is a placeholder for above todo <28-08-22, kunzaatko>
      map('n', '<leader>dd', function()
        return require('neogen').generate { type = 'func' }
      end, { silent = true, desc = 'generate doc' })
      map('n', '<leader>dc', function()
        return require('neogen').generate { type = 'class' }
      end, { silent = true, desc = 'generate class doc' })
      map('n', '<leader>df', function()
        return require('neogen').generate { type = 'func' }
      end, { silent = true, desc = 'generate function doc' })
      map('n', '<leader>dt', function()
        return require('neogen').generate { type = 'type' }
      end, { silent = true, desc = 'generate type doc' })
      map('n', '<C-l>', function()
        return require('neogen').jump_next()
      end, { silent = true, desc = 'jump to next documentation tabstop' })
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
  },
  -- }}}
}
return M
