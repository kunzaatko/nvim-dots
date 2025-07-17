vim.keymap.set('n', '<LocalLeader>d', function()
  require('neogen').generate()
end, { desc = 'Generate docstring for function/class', buffer = true })
