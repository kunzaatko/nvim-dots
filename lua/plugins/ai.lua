local M = {
  {
    -- TODO: Add opencode through the ACP protocol <10-03-2026>
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
    'nickvandyke/opencode.nvim',
    lazy = false,
    dependencies = {
      {
        ---@module "snacks"
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              ---@param picker snacks.Picker
              opencode_send = function(picker)
                local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
                  return item.file
                      and require('opencode').format { path = item.file, from = item.pos, to = item.end_pos }
                    or item.text
                end, picker:selected { fallback = true })

                require('opencode').prompt(table.concat(items, ', ') .. ' ')
              end,
            },
            win = {
              input = {
                keys = {
                  ['<C-.>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      local term_util = require 'util.terminal'
      local term = require 'snacks.terminal'

      local opencode_cmd = 'opencode --port'
      ---@type snacks.terminal.Config
      local snacks_terminal_opts = term_util.get_repl_opts(opencode_cmd, '<C-.>', {
        win = {
          enter = false,
          on_win = function(win)
            require('opencode.terminal').setup(win.win) -- Set up keymaps and clean-up for an arbitrary terminal
          end,
        },
        auto_insert = true,
        start_insert = true,
      })

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            term.open(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }
      vim.keymap.set({ 'n', 't' }, '<C-.>', function()
        require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
      end, { desc = 'Toggle OpenCode' })

      -- Show upon submitting prompt
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'OpencodeEvent:tui.command.execute' },
        callback = function(args)
          ---@type opencode.server.Event
          local event = args.data.event
          if event.properties.command == 'prompt.submit' then
            local win = require('snacks.terminal').get(opencode_cmd, { create = false })
            if win then
              win:show()
            end
          end
        end,
      })

      vim.keymap.set('v', '<C-.>', function()
        require('opencode').ask '@this: '
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, 'g<C-.>', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })

      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })
    end,
  },
}

return M
