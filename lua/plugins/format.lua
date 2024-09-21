return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  config = function()
    local opts = {
      formatters = {
        typstyle = {
          command = 'typstyle',
          args = { '-c' .. vim.opt.textwidth:get() },
        },
      },
      formatters_by_ft = {
        typst = { 'typstyle' },
        -- TODO: Setup more formatters <12-05-24>
      },
      format_on_save = {
        timeout_ms = 500,
      },
    }
    require('conform').setup(opts)

    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      -- TODO: Test whether this works and does not stall the further writing <09-09-24>
      require('conform').format { async = true, lsp_fallback = true, range = range }
    end, { range = true })
  end,
}
