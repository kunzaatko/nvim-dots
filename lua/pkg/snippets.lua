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
      if vim.bo.filetype == 'tex' then
        vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = _G.TEXUtils.get_tex_root():joinpath('snips').filename
      end
      vim.api.nvim_set_keymap(
        'x',
        '<C-l>',
        ':lua vim.call("UltiSnips#SaveLastVisualSelection")<CR>gvs',
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        's',
        '<C-l>',
        ':lua vim.call("UltiSnips#ExpandSnippet")<CR>',
        { noremap = true, silent = true }
      )
    end,
  },
  -- }}}

  -- TODO: Module documentation generation <16-01-22, kunzaatko> --
  -- 'danymat/neogen' -- generate documentation for functions based on treesitter {{{
  {
    'danymat/neogen',
    keys = { '<leader>dd', '<leader>dc', '<leader>df', '<leader>dt' },
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
      require('neogen').setup { enabled = true }
      vim.api.nvim_set_keymap(
        'n',
        '<leader>dd',
        "<Cmd>lua require'neogen'.generate()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>dc',
        "<Cmd>lua require'neogen'.generate({ type = 'class' })<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>df',
        "<Cmd>lua require'neogen'.generate({ type = 'func' })<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>dt',
        "<Cmd>lua require'neogen'.generate({ type = 'type' })<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<C-l>',
        "<Cmd>lua require'neogen'.jump_next()<CR>",
        { noremap = true, silent = true }
      )
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
  },
  -- }}}
}
return M
