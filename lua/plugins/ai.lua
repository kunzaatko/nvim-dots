local M = {
  {
    'jackMort/ChatGPT.nvim',
    dependencies = {
      { 'MunifTanjim/nui.nvim', name = 'nui' },
      { 'nvim-lua/plenary.nvim', name = 'plenary' },
      { 'nvim-telescope/telescope.nvim', name = 'telescope' },
    },
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTEditWithInstructions',
      'ChatGPTRun',
    },
    opts = {
      openai_params = {
        model = 'gpt-3.5-turbo-1106',
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 1000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
    },
  },
  {
    'robitx/gp.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '€',
        '<cmd>GpChatToggle<CR>',
        desc = 'GPT Toggle',
      },
      {
        '<leader>ac',
        '<cmd>GpChatFinder<CR>',
        desc = 'GPT Finder',
      },
    },
    opts = {
      openai_api_key = os.getenv 'OPENAI_API_KEY',
      -- chat_model = { model = 'gpt-3.5-turbo-1106', temperature = 1.1, top_p = 1 },
      -- command_model = { model = 'gpt-3.5-turbo-1106', temperature = 1.1, top_p = 1 },
      hooks = {
        InspectPlugin = function(plugin, params)
          print(string.format('Plugin structure:\n%s', vim.inspect(plugin)))
          print(string.format('Command params:\n%s', vim.inspect(params)))
        end,

        -- GpImplement rewrites the provided selection/range based on comments in the code
        Implement = function(gp, params)
          local template = 'Having following from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please rewrite this code according to the comment instructions.'
            .. '\n\nRespond only with the snippet of finalized code:'

          gp.Prompt(
            params,
            gp.Target.rewrite,
            nil, -- command will run directly without any prompting for user input
            gp.config.command_model,
            template,
            gp.config.command_system_prompt
          )
        end,
        vim.api.nvim_create_autocmd('BufRead', {
          group = vim.api.nvim_create_augroup('GpChat', {}),
          pattern = vim.fn.stdpath('data'):gsub('/$', '') .. '/gp/chats/*.md',
          callback = function()
            vim.opt_local.number = false
            vim.opt_local.textwidth = 80
          end,
        }),
        -- your own functions can go here, see README for more examples like
        -- :GpExplain, :GpUnitTests.., :GpBetterChatNew, ..
      },
    },
    config = function(_, opts)
      require('gp').setup(opts)
      require('which-key').register({
        -- ...
        ['<C-g>'] = {
          c = { ":<C-u>'<,'>GpChatNew<cr>", 'Visual Chat New' },
          v = { ":<C-u>'<,'>GpChatPaste<cr>", 'Visual Chat Paste' },
          t = { ":<C-u>'<,'>GpChatToggle<cr>", 'Visual Popup Chat' },

          ['<C-x>'] = { ":'<,'>GpChatNew split<CR>", 'Visual Chat New split' },
          ['<C-v>'] = { ":'<,'>GpChatNew vsplit<CR>", 'Visual Chat New vsplit' },
          ['<C-t>'] = { ":'<,'>GpChatNew tabnew<CR>", 'Visual Chat New tabnew' },

          r = { ":<C-u>'<,'>GpRewrite<cr>", 'Visual Rewrite' },
          a = { ":<C-u>'<,'>GpAppend<cr>", 'Visual Append' },
          b = { ":<C-u>'<,'>GpPrepend<cr>", 'Visual Prepend' },
          e = { ":<C-u>'<,'>GpEnew<cr>", 'Visual Enew' },
          p = { ":<C-u>'<,'>GpPopup<cr>", 'Visual Popup' },
          s = { '<cmd>GpStop<cr>', 'Stop' },

          -- optional Whisper commands
          w = { ":<C-u>'<,'>GpWhisper<cr>", 'Whisper' },
          R = { ":<C-u>'<,'>GpWhisperRewrite<cr>", 'Whisper Visual Rewrite' },
          A = { ":<C-u>'<,'>GpWhisperAppend<cr>", 'Whisper Visual Append' },
          B = { ":<C-u>'<,'>GpWhisperPrepend<cr>", 'Whisper Visual Prepend' },
          E = { ":<C-u>'<,'>GpWhisperEnew<cr>", 'Whisper Visual Enew' },
          P = { ":<C-u>'<,'>GpWhisperPopup<cr>", 'Whisper Visual Popup' },
        },
        -- ...
      }, {
        mode = 'v', -- VISUAL mode
        prefix = '',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })

      -- NORMAL mode mappings
      require('which-key').register({
        -- ...
        ['<C-g>'] = {
          c = { '<cmd>GpChatNew<cr>', 'New Chat' },
          t = { '<cmd>GpChatToggle<cr>', 'Toggle Popup Chat' },
          f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

          ['<C-x>'] = { '<cmd>GpChatNew split<cr>', 'New Chat split' },
          ['<C-v>'] = { '<cmd>GpChatNew vsplit<cr>', 'New Chat vsplit' },
          ['<C-t>'] = { '<cmd>GpChatNew tabnew<cr>', 'New Chat tabnew' },

          r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },
          a = { '<cmd>GpAppend<cr>', 'Append' },
          b = { '<cmd>GpPrepend<cr>', 'Prepend' },
          e = { '<cmd>GpEnew<cr>', 'Enew' },
          p = { '<cmd>GpPopup<cr>', 'Popup' },
          s = { '<cmd>GpStop<cr>', 'Stop' },

          -- optional Whisper commands
          w = { '<cmd>GpWhisper<cr>', 'Whisper' },
          R = { '<cmd>GpWhisperRewrite<cr>', 'Whisper Inline Rewrite' },
          A = { '<cmd>GpWhisperAppend<cr>', 'Whisper Append' },
          B = { '<cmd>GpWhisperPrepend<cr>', 'Whisper Prepend' },
          E = { '<cmd>GpWhisperEnew<cr>', 'Whisper Enew' },
          P = { '<cmd>GpWhisperPopup<cr>', 'Whisper Popup' },
        },
        -- ...
      }, {
        mode = 'n', -- NORMAL mode
        prefix = '',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })
      -- INSERT mode mappings
      require('which-key').register({
        -- ...
        ['<C-g>'] = {
          c = { '<cmd>GpChatNew<cr>', 'New Chat' },
          t = { '<cmd>GpChatToggle<cr>', 'Toggle Popup Chat' },
          f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

          ['<C-x>'] = { '<cmd>GpChatNew split<cr>', 'New Chat split' },
          ['<C-v>'] = { '<cmd>GpChatNew vsplit<cr>', 'New Chat vsplit' },
          ['<C-t>'] = { '<cmd>GpChatNew tabnew<cr>', 'New Chat tabnew' },

          r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },
          a = { '<cmd>GpAppend<cr>', 'Append' },
          b = { '<cmd>GpPrepend<cr>', 'Prepend' },
          e = { '<cmd>GpEnew<cr>', 'Enew' },
          p = { '<cmd>GpPopup<cr>', 'Popup' },
          s = { '<cmd>GpStop<cr>', 'Stop' },

          -- optional Whisper commands
          w = { '<cmd>GpWhisper<cr>', 'Whisper' },
          R = { '<cmd>GpWhisperRewrite<cr>', 'Whisper Inline Rewrite' },
          A = { '<cmd>GpWhisperAppend<cr>', 'Whisper Append' },
          B = { '<cmd>GpWhisperPrepend<cr>', 'Whisper Prepend' },
          E = { '<cmd>GpWhisperEnew<cr>', 'Whisper Enew' },
          P = { '<cmd>GpWhisperPopup<cr>', 'Whisper Popup' },
        },
        -- ...
      }, {
        mode = 'i', -- INSERT mode
        prefix = '',
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true,
      })
    end,
  },
  -- NOTE: Testing if better than codeium -- not better (probably the whole repo context) <31-05-24>
  {
    'huggingface/llm.nvim',
    event = 'VeryLazy',
    enabled = false,
    opts = {
      enable_suggestions_on_startup = true,
      api_token = os.getenv 'HUGGINGFACE_API_TOKEN',
      accept_keymap = '<C-f>',
    },
  },
  {
    'Exafunction/codeium.vim',
    event = { 'InsertEnter', 'VeryLazy' },
    enabled = true,
    cmd = { 'Codeium', 'CodeiumAuto', 'CodeiumEnable', 'CodeiumDisable', 'CodeiumManual' },
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
    end,
  },
}

return M
