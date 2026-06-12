-- FIX: The symbols in the keywords break the functionality... See https://github.com/folke/todo-comments.nvim/issues/213 <17-04-2026>
return {
  {
    'folke/todo-comments.nvim',
    name = 'todo-comments',
    dependencies = { 'nvim-lua/plenary.nvim', name = 'plenary' },
    event = 'BufReadPost',
    opts = {
      highlight = { keyword = 'fg', after = '' },
      keywords = {
        FIX = {
          icon = static.icons.comments.bug .. ' ',
          color = 'error',
          alt = { 'FIX?', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'CHECK', 'PERF!' },
        },
        TODO = { icon = static.icons.comments.todo .. ' ', color = 'info', alt = { 'TODO!', 'TODO?' } },
        HACK = { icon = static.icons.comments.hack .. ' ', color = 'warning' },
        WARN = {
          icon = static.icons.diagnostics.Warn .. ' ',
          color = 'warning',
          alt = { 'WARNING', 'XXX', 'QUESTION', 'POLICY' },
        },
        PERF = { icon = static.icons.comments.performance .. ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = {
          icon = static.icons.comments.note .. ' ',
          color = 'hint',
          alt = { 'INFO', 'IDEA', 'IDEA!', 'RESEARCH', 'note' },
        },
      },
    },
  },
  { -- 'norcalli/nvim-colorizer.lua': Highlighting RGB colour strings
    'norcalli/nvim-colorizer.lua',
    cmd = { 'ColorizerToggle', 'ColorizerReloadAllBuffers', 'ColorizerDetachFromBuffer', 'ColorizerAttachToBuffer' },
    config = true,
  },
  -- FIX: There is an issue with keybinding. I should only copy the parts that I want into my config <06-07-25>
  -- TODO: Configure the `foldtext` to shorten the `"lines"` chunk <06-07-25>
  -- {
  --   'chrisgrieser/nvim-origami',
  --   event = 'VeryLazy',
  --   enbaled = false,
  --   opts = {
  --     foldKeymaps = { setup = false },
  --   },
  --   init = function()
  --     vim.opt.foldlevel = 99
  --     vim.opt.foldlevelstart = 99
  --   end,
  -- },
  -- FIX: I want to use `zm` and `zr`, `zR` and `zM` as in original nvim. Should override nvim-ufo commands and have it
  -- work as indented. <20-03-25>
  -- TODO: Fold documentation strings by default when opened. This can be set through the options <30-03-25>
  {
    'kevinhwang91/nvim-ufo',
    name = 'ufo',
    enabled = false,
    dependencies = {
      'kevinhwang91/promise-async',
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require 'statuscol.builtin'
          require('statuscol').setup {
            relculright = true,
            ft_ignore = { 'NeogitStatus', 'query', 'snacks_dashboard' },
            bt_ignore = { 'terminal' },
            segments = {
              {
                sign = {
                  name = { 'GitSigns' },
                  namespace = { 'gitsigns' },
                  maxwidth = 1,
                  colwidth = 1,
                  auto = false,
                  fillchar = ' ',
                  fillcharhl = 'StatusColumnSeparator',
                },
                click = 'v:lua.ScSa',
              },
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              {
                sign = {
                  name = {
                    'LightBulbSign',
                    'Dap',
                    'neotest',
                    'Diagnostic',
                    'todo',
                  },
                  maxwidth = 1,
                  colwidth = 2,
                  auto = false,
                },
                click = 'v:lua.ScSa',
              },
              -- { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          }
        end,
      },
    },
    lazy = false,
    ---@type UfoConfig
    opts = {
      provider_selector = function(_, ftype, _)
        return ftype == 'julia' and { 'lsp', 'treesitter' } or { 'lsp', 'indent' }
      end,
      preview = {
        mappings = {
          scrollB = '<C-b>',
          scrollF = '<C-f>',
          scrollU = '<C-u>',
          scrollD = '<C-d>',
        },
      },
    },
    config = function(_, opts)
      -- NOTE: Necessary to override for nvim-ufo to work <20-03-25>
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
      vim.keymap.set('n', 'zK', require('ufo').peekFoldedLinesUnderCursor, { desc = 'Peek folded lines' })

      require('util.lsp').add_capabilities {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      }
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      opts.fold_virt_text_handler = handler
      require('ufo').setup(opts)
    end,
  },
  {
    'j-hui/fidget.nvim',
    name = 'fidget',
    event = 'LspAttach',
    config = true,
  },
  -- TODO: Disable on non-focused windows or at least change the settings so that it does not show diagnostics <02-05-23>
  {
    'petertriho/nvim-scrollbar',
    -- enabled = false,
    event = 'BufReadPost',
    opts = {
      excluded_filetypes = { 'prompt', 'TelescopePrompt', 'noice', 'notify' },
    },
  },
  {
    'tzachar/highlight-undo.nvim',
    keys = { 'u', '<C-r>' },
    config = function()
      -- TODO: Consider using background or different colour or italic flash <08-10-24>
      vim.api.nvim_set_hl(
        0,
        'HighlightUndo',
        { fg = vim.api.nvim_get_hl(0, { name = '@diff.minus', link = false }).fg }
      )
      vim.api.nvim_set_hl(0, 'HighlightRedo', { fg = vim.api.nvim_get_hl(0, { name = '@diff.plus', link = false }).fg })
      require('highlight-undo').setup()
    end,
  },
  -- TODO: Test whether this overwrites the number that is given by `neocodeium` <30-03-25>
  {
    'mawkler/modicator.nvim',
    enabled = false, -- FIX: Broken with treesitter <07-07-25>
    event = 'VeryLazy',
    config = function(_, opts)
      local set = vim.api.nvim_set_hl
      -- NOTE: Chosen to match the colours in heirline config <kunzaatko>
      set(0, 'NormalMode', { fg = '#BE6069', bg = 'bg' })
      set(0, 'InsertMode', { fg = '#EBCA89', bg = 'bg' })
      set(0, 'VisualMode', { fg = '#81A1C1', bg = 'bg' })
      set(0, 'CommandMode', { fg = '#B48EAD', bg = 'bg' })
      set(0, 'ReplaceMode', { fg = '#A77B9F', bg = 'bg' })
      set(0, 'SelectMode', { fg = '#D18771', bg = 'bg' })
      set(0, 'TerminalMode', { fg = 'fg', bg = 'bg' })
      set(0, 'TerminalNormalMode', { fg = 'fg', bg = 'bg' })
      require('modicator').setup(opts)
    end,
  },
  -- TODO: Testing whether it does not lag the editor... Is it switched to async treesitter API? <22-05-25>
  -- TODO: Configure the highlight groups <21-05-25>
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPost',
    init = function()
      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
        },
        priority = {
          [''] = 110,
        },
      }
    end,
  },
}
