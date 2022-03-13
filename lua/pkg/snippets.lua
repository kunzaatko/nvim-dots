local utils = require 'pkg.utils'
local M = {
  -- TODO: Todo comment expand at beginning of line <16-01-22, kunzaatko> --
  -- TODO: Add '<leader>' mappings for editing snippet files <16-01-22, kunzaatko> --
  -- 'sirver/ultisnips' -- snippets {{{
  {
    'sirver/ultisnips',
    event = 'InsertEnter',
    setup = function()
      -- Snippets variables
      vim.g.snips_author = 'kunzaatko'
      vim.g.snips_email = 'martinkunz@email.cz'
      vim.g.snips_github = 'https://github.com/kunzaatko'
      -- UltiSnips
      vim.opt.runtimepath = vim.opt.runtimepath + { vim.fn.expand '$PWD' }
      vim.g.UltiSnipsSnippetDirectories = { 'snips' } -- ensure that snippets directories are not recursively searched
      vim.g.UltiSnipsEnableSnipMate = 0 -- only look for UltiSnips snippets
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0 -- for using tab in nvim-cmp
    end,
    config = function()
      local map = vim.keymap.set
      if vim.bo.filetype == 'tex' then
        vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = _G.TEXUtils.get_tex_root():joinpath('snips').filename
      end
      map('x', '<C-l>', ':lua vim.call("UltiSnips#SaveLastVisualSelection")<CR>gvs', { silent = true })
      map('s', '<C-l>', ':lua vim.call("UltiSnips#ExpandSnippet")<CR>', { silent = true })
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
      require('neogen').setup { enabled = true }
      map('n', '<leader>dd', function()
        return require('neogen').generate()
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
