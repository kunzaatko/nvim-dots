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
        desc = 'LLM Chat Toggle',
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

      require('gp').setup(opts)
      require('which-key').add {
        -- ...
        {
          mode = { 'v' }, -- VISUAL mode
          { '<C-g><C-t>', ":'<,'>GpChatNew tabnew<CR>", desc = 'Visual Chat New tabnew', nowait = true, remap = false },
          { '<C-g><C-v>', ":'<,'>GpChatNew vsplit<CR>", desc = 'Visual Chat New vsplit', nowait = true, remap = false },
          { '<C-g><C-x>', ":'<,'>GpChatNew split<CR>", desc = 'Visual Chat New split', nowait = true, remap = false },
          { '<C-g>A', ":<C-u>'<,'>GpWhisperAppend<cr>", desc = 'Whisper Visual Append', nowait = true, remap = false },
          {
            '<C-g>B',
            ":<C-u>'<,'>GpWhisperPrepend<cr>",
            desc = 'Whisper Visual Prepend',
            nowait = true,
            remap = false,
          },
          { '<C-g>E', ":<C-u>'<,'>GpWhisperEnew<cr>", desc = 'Whisper Visual Enew', nowait = true, remap = false },
          { '<C-g>P', ":<C-u>'<,'>GpWhisperPopup<cr>", desc = 'Whisper Visual Popup', nowait = true, remap = false },
          {
            '<C-g>R',
            ":<C-u>'<,'>GpWhisperRewrite<cr>",
            desc = 'Whisper Visual Rewrite',
            nowait = true,
            remap = false,
          },
          { '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", desc = 'Visual Append', nowait = true, remap = false },
          { '<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", desc = 'Visual Prepend', nowait = true, remap = false },
          { '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", desc = 'Visual Chat New', nowait = true, remap = false },
          { '<C-g>e', ":<C-u>'<,'>GpEnew<cr>", desc = 'Visual Enew', nowait = true, remap = false },
          { '<C-g>p', ":<C-u>'<,'>GpPopup<cr>", desc = 'Visual Popup', nowait = true, remap = false },
          { '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", desc = 'Visual Rewrite', nowait = true, remap = false },
          { '<C-g>s', '<cmd>GpStop<cr>', desc = 'Stop', nowait = true, remap = false },
          { '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", desc = 'Visual Popup Chat', nowait = true, remap = false },
          { '<C-g>v', ":<C-u>'<,'>GpChatPaste<cr>", desc = 'Visual Chat Paste', nowait = true, remap = false },
          { '<C-g>w', ":<C-u>'<,'>GpWhisper<cr>", desc = 'Whisper', nowait = true, remap = false },
        },
      }

      -- NORMAL & INSERT mode mappings
      require('which-key').add {
        -- ...
        {
          mode = { 'i', 'n' },
          { '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', desc = 'New Chat tabnew', nowait = true, remap = false },
          { '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', desc = 'New Chat vsplit', nowait = true, remap = false },
          { '<C-g><C-x>', '<cmd>GpChatNew split<cr>', desc = 'New Chat split', nowait = true, remap = false },
          { '<C-g>A', '<cmd>GpWhisperAppend<cr>', desc = 'Whisper Append', nowait = true, remap = false },
          { '<C-g>B', '<cmd>GpWhisperPrepend<cr>', desc = 'Whisper Prepend', nowait = true, remap = false },
          { '<C-g>E', '<cmd>GpWhisperEnew<cr>', desc = 'Whisper Enew', nowait = true, remap = false },
          { '<C-g>P', '<cmd>GpWhisperPopup<cr>', desc = 'Whisper Popup', nowait = true, remap = false },
          { '<C-g>R', '<cmd>GpWhisperRewrite<cr>', desc = 'Whisper Inline Rewrite', nowait = true, remap = false },
          { '<C-g>a', '<cmd>GpAppend<cr>', desc = 'Append', nowait = true, remap = false },
          { '<C-g>b', '<cmd>GpPrepend<cr>', desc = 'Prepend', nowait = true, remap = false },
          { '<C-g>c', '<cmd>GpChatNew<cr>', desc = 'New Chat', nowait = true, remap = false },
          { '<C-g>e', '<cmd>GpEnew<cr>', desc = 'Enew', nowait = true, remap = false },
          { '<C-g>f', '<cmd>GpChatFinder<cr>', desc = 'Chat Finder', nowait = true, remap = false },
          { '<C-g>p', '<cmd>GpPopup<cr>', desc = 'Popup', nowait = true, remap = false },
          { '<C-g>r', '<cmd>GpRewrite<cr>', desc = 'Inline Rewrite', nowait = true, remap = false },
          { '<C-g>s', '<cmd>GpStop<cr>', desc = 'Stop', nowait = true, remap = false },
          { '<C-g>t', '<cmd>GpChatToggle<cr>', desc = 'Toggle Popup Chat', nowait = true, remap = false },
          { '<C-g>w', '<cmd>GpWhisper<cr>', desc = 'Whisper', nowait = true, remap = false },
        },
      }
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
