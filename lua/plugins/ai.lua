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
      providers = {
        openai = {
          secret = { 'pass', 'openai/API_key_neovim' },
        },
        copilot = {
          secret = { 'pass', 'github.com/oauth_token_copilot_kunzaatko' },
        },
        anthropic = {
          secret = { 'pass', 'anthropic.com/API_key_neovim' },
        },
        pplx = {
          secret = { 'pass', 'perplexity.ai/API_key_neovim' },
        },
      },
      hooks = {
        -- GpUnitTests: Writes unit tests for the selected code
        UnitTests = function(gp, params)
          local agent = gp.get_command_agent()
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by writing table driven unit tests for the code above.'
          gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
        end,
        -- GpImplement: Rewrites the provided selection/range based on comments in the code
        Implement = function(gp, params)
          local agent = gp.get_command_agent()
          local template = 'Having following from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please rewrite this code according to the comment instructions.'
            .. '\n\nRespond only with the snippet of finalized code:'
          gp.Prompt(params, gp.Target.rewrite, nil, agent.model, template, agent.system_prompt)
        end,
        -- FIX: https://github.com/Robitx/gp.nvim/issues/154 <16-07-24, kunzaatko>
        -- GpExplain: Explains the provided selection/range
        Explain = function(gp, params)
          local agent = gp.get_chat_agent()
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by explaining the code above.'
          gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,
        -- FIX: https://github.com/Robitx/gp.nvim/issues/154 <16-07-24, kunzaatko>
        -- GpCodeReview: Review the provided selection/range
        CodeReview = function(gp, params)
          local agent = gp.get_chat_agent()
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please analyze for code smells and suggest improvements.'
          gp.Prompt(params, gp.Target.enew 'markdown', nil, agent.model, template, agent.system_prompt)
        end,
        -- FIX: Look to suggest synonyms... This has the same problem often. <16-07-24>
        -- GpTranslator: Translates the provided selection/range
        Translator = function(gp, params)
          local agent = gp.get_command_agent()
          local chat_system_prompt = 'You are a Translator, please translate between the detected language of the input I am giving you and '
            .. (params.args[1] or 'Czech')
            .. '.\n Respond only with the translated text.\n'
          gp.Prompt(params, gp.Target.popup, nil, agent.model, '{{selection}}', chat_system_prompt)
        end,
        -- GpDocumentation: Generate documentation for the provided function
        Documentation = function(gp, params)
          local agent = gp.get_command_agent()
          local template = 'I have the following function:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please generate comprehensive documentation for this function, including:'
            .. '\n- A brief description of what the function does'
            .. '\n- Parameters and their types'
            .. '\n- Return value and its type'
            .. '\n- Any side effects or important notes'
            .. '\n\nRespond with the correctly quoted documentation in the standard format for the `{{filetype}}` language.'
          gp.Prompt(params, gp.Target.prepend, nil, agent.model, template, agent.system_prompt)
        end,
        -- FIX: This does not work because the visual markers are for full lines and not for ranges that include only
        -- some words for the line... It could be solved perhaps by calling some function that gets the content of the
        -- last visual selection. <16-07-24>
        -- SuggestSynonyms: Suggest synonyms for the provided word
        SuggestSynonyms = function(gp, params)
          local agent = gp.get_command_agent()
          local template = 'I have the following phrase:\n\n'
            .. '{{selection}}'
            .. 'Please suggest synonyms or alternate phases for this phrase.'
          gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,
        -- TODO: I would like to have a hook for _rephrasing_ and good writing suggestions <16-07-24>
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('GpChat', {}),
        pattern = vim.fn.stdpath('data'):gsub('/$', '') .. '/gp/chats/*.md',
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.textwidth = 80
        end,
      })

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
