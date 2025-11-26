local M = {
  {
    'olimorris/codecompanion.nvim',
    cmd = 'CodeCompanion',
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
      -- TODO: Add an autocommand that watches the buffer that launched the chat and when it is closed, the chat should
      -- be also closed <25-04-25>
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
      { 'nvim-lua/plenary.nvim', name = 'plenary' },
      'ravitemer/mcphub.nvim',
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
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            show_result_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
          },
        },
      },
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
    'ravitemer/mcphub.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', name = 'plenary' },
    },
    cmd = 'MCPHub',
    build = 'npm install -g mcp-hub@latest',
    config = true,
  },
  -- TODO: Add a status line component that shows the number of completions instead of only the icon <06-07-25>
  {
    'monkoose/neocodeium',
    event = { 'InsertEnter', 'VeryLazy' },
    cmd = 'NeoCodeium',
    keys = {
      {
        '<A-f>',
        function()
          require('neocodeium').accept()
        end,
        mode = 'i',
        desc = 'Accept Codeium completion',
      },

      {
        '<A-d>',
        function()
          require('neocodeium').cycle_or_complete()
        end,
        mode = 'i',
        desc = 'Cycle Codeium completion',
      },
      {
        '<A-s>',
        function()
          require('neocodeium').cycle_or_complete(-1)
        end,
        mode = 'i',
        desc = 'Cycle Codeium completion reverse',
      },
    },
    opts = {
      filetypes = {
        snacks_picker_input = false,
      },
      show_label = false, -- Do not show the label with the completion status in the `signcolumn`
    },
  },
  {
    'NickvanDyke/opencode.nvim',
    lazy = false,
    keys = {
      -- Recommended keymaps
      {
        '<leader>oA',
        function()
          require('opencode').ask()
        end,
        desc = 'Ask opencode',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask '@cursor: '
        end,
        desc = 'Ask opencode about this',
        mode = 'n',
      },
      {
        '<leader>oa',
        function()
          require('opencode').ask '@selection: '
        end,
        desc = 'Ask opencode about this',
        mode = 'v',
      },
      {
        'Đ',
        function()
          require('opencode').ask '@selection: '
        end,
        desc = 'Ask opencode about selection',
        mode = 'v',
      },
      {
        'Đ',
        function()
          require('opencode').toggle()
        end,
        desc = 'Toggle embedded opencode',
      },
      {
        '<leader>on',
        function()
          require('opencode').command 'session_new'
        end,
        desc = 'New session',
      },
      {
        '<leader>oy',
        function()
          require('opencode').command 'messages_copy'
        end,
        desc = 'Copy last message',
      },
      {
        '<S-C-u>',
        function()
          require('opencode').command 'messages_half_page_up'
        end,
        desc = 'Scroll messages up',
      },
      {
        '<S-C-d>',
        function()
          require('opencode').command 'messages_half_page_down'
        end,
        desc = 'Scroll messages down',
      },
      {
        '<leader>op',
        function()
          require('opencode').select()
        end,
        desc = 'Select prompt',
        mode = { 'n', 'v' },
      },
      -- Example: keymap for custom prompt
      {
        '<leader>oe',
        function()
          require('opencode').prompt 'Explain @cursor and its context'
        end,
        desc = 'Explain code near cursor',
      },
    },
    config = function()
      local config = require 'opencode.config'
      config.opts = vim.tbl_deep_extend('force', config.opts, {
        terminal = {
          win = {
            keys = require('util.terminal').TERMINAL_NAV_KEYS,
          },
        },
      })
    end,
  },
}

return M
