local M = {
  {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '€',
        function()
          require('codecompanion').toggle()
        end,
        mode = { 'n', 'v' },
        noremap = true,
        silent = true,
        desc = 'LLM Chat Toggle',
      },
      -- FIX: I would like to specify the use of gemini-2.0-flash for git commits but use something other by default.
      -- I could not find a way to do this with the `codecompanion` API at the moment so I use gemini-2.0-flash by
      -- default for every chat invocation. <25-03-25>
      {
        '<localleader>a',
        function()
          require('codecompanion').prompt 'commit'
        end,
        mode = { 'n', 'v' },
        ft = 'gitcommit',
        noremap = true,
        silent = true,
        desc = 'LLM generate commit message',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
        opts = { file_types = { 'markdown', 'codecompanion' } },
      },
    },
    opts = {
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'cmd:pass anthropic.com/API_key_neovim',
            },
          })
        end,
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = 'cmd:pass openai.com/API_key_neovim',
            },
          })
        end,
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            env = {
              api_key = 'cmd:pass github.com/oauth_token_copilot_kunzaatko',
            },
          })
        end,
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = 'cmd:pass google.com/API_key_nevypustsupyven_aistudio_neovim',
            },
          })
        end,
        ['gemini-1.5-flash'] = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = 'cmd:pass google.com/API_key_nevypustsupyven_aistudio_neovim',
            },
            schema = {
              model = {
                default = 'gemini-1.5-flash',
              },
            },
          })
        end,
        deepseek = function()
          return require('codecompanion.adapters').extend('deepseek', {
            env = {
              api_key = 'cmd:pass deepseek.com/API_key_neovim',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'gemini',
        },
        inline = {
          -- NOTE: Currently Google gemini-2.0-flash model is free of charge with limited per minute tokens, which is
          -- quite generous <25-03-25>
          -- adapter = 'gemini',
          adapter = 'gemini',
        },
        cmd = {
          adapter = 'gemini',
        },
      },
      display = { chat = { show_settings = true } }, -- NOTE: When this is set, the adapter cannot be modified <25-03-25>
    },
    config = function(_, opts)
      local codecompanion_group = vim.api.nvim_create_augroup('CodeCompanionAutoSave', { clear = true })

      local function save_codecompanion_buffer(bufnr)
        local save_dir = vim.fn.stdpath('data'):gsub('/$', '') .. '/codecompanion/chats/'
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)

        -- Extract the unique ID from the buffer name
        local id = bufname:match '%[CodeCompanion%] (%d+)'
        local date = os.date '%Y-%m-%d'
        local save_path

        if id then
          -- Use date plus ID to ensure uniqueness
          save_path = save_dir .. date .. '_codecompanion_' .. id .. '.md'
        else
          -- Fallback with timestamp to ensure uniqueness if no ID
          save_path = save_dir .. date .. '_codecompanion_' .. os.date '%H%M%S' .. '.md'
        end

        -- Write buffer content to file
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local file = io.open(save_path, 'w')
        if file then
          file:write(table.concat(lines, '\n'))
          file:close()
        end
      end

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged', 'BufLeave', 'FocusLost' }, {
        group = codecompanion_group,
        callback = function(args)
          local bufnr = args.buf
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          if bufname:match '%[CodeCompanion%]' then
            save_codecompanion_buffer(bufnr)
          end
        end,
      })
      require('codecompanion').setup(opts)
    end,
  },
  {
    'Exafunction/codeium.vim',
    event = { 'InsertEnter', 'VeryLazy' },
    enabled = true,
    cmd = { 'Codeium', 'CodeiumAuto', 'CodeiumEnable', 'CodeiumDisable', 'CodeiumManual', 'CodeiumChat' },
    config = function()
      vim.g.codeium_enabled = true
      vim.keymap.set('i', '<c-f>', vim.fn['codeium#Accept'], { expr = true })
      vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](1)
      end, { expr = true })
      vim.keymap.set('i', '<c-.>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
      end, { expr = true })
      vim.keymap.set('n', '<c-g><c-g>', vim.fn['codeium#Chat'], { expr = true, desc = 'Open Codeium Chat' })
      vim.keymap.set('i', '<c-x>', vim.fn['codeium#Clear'], { expr = true })

      vim.api.nvim_create_user_command('CodeiumChat', function()
        vim.call 'codeium#Chat'
      end, {})
    end,
  },
}

return M
