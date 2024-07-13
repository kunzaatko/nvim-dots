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

      -- NORMAL mode mappings
      require('which-key').add {
        {
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
      -- INSERT mode mappings
      require('which-key').add {
        -- ...
        {
          mode = { 'i' },
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
