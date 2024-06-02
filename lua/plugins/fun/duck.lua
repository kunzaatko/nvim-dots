return {
  'tamton-aquib/duck.nvim',
  name = 'duck',
  cmd = { 'Duck' },
  config = function()
    vim.api.nvim_create_user_command('Duck', function(opts)
      if opts.args == 'hatch' then
        require('duck').hatch()
      elseif opts.args == 'cook' then
        require('duck').cook()
      end
    end, {
      nargs = 1,
      complete = function(_, line)
        local args = { 'hatch', 'cook' }
        local l = vim.split(line, '%s+', {})

        if #l == 2 then
          return vim.tbl_filter(function(val)
            return vim.startswith(val, l[2])
          end, args)
        end
      end,
    })
  end,
}
