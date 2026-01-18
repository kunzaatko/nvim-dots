return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo', 'FormatDisable', 'FormatEnable', 'Format' },
  opts = {
    formatters = {
      typstyle = {
        command = 'typstyle',
        args = { '-c' .. vim.opt.textwidth:get() },
      },
      mdformat = {
        prepend_args = {
          '--extension',
          'tables',
        },
      },
      -- latexindent = {
      --   prepend_args = {
      --     '-y="defaultIndent:\\"  \\""',
      --   },
      -- },
    },
    formatters_by_ft = {
      typst = { 'typstyle' },
      fish = { 'fish_indent' },
      just = { 'just' },
      json = { 'jq' },
      css = { 'prettier' },
      scss = { 'prettier' },
      sass = { 'prettier' },
      sh = { 'shfmt' },
      -- latex = { 'latexindent' },
      -- tex = { 'latexindent' },
      python = { 'ruff_organize_imports', 'ruff_fix', 'ruff_format' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      lua = { 'stylua' },
      toml = { 'taplo' },
      markdown = { 'mdformat' },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function(_, opts)
    require('conform').setup(opts)

    -- require('conform').formatters.mdformat = {
    --   prepend_args = {
    --     '--extension',
    --     'tables',
    --   },
    -- }

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
      vim.notify(
        'Autoformat-on-save OFF' .. (vim.g.disable_autoformat and ' (global)' or ''),
        vim.log.levels.INFO,
        { title = 'Format', icon = static.icons.quote }
      )
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify('Autoformat-on-save ON', vim.log.levels.INFO, { title = 'Format', icon = static.icons.quote })
    end, {
      desc = 'Re-enable autoformat-on-save',
    })

    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format { async = true, lsp_fallback = true, range = range }
    end, { range = true })
  end,
}
