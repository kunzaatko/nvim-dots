return {
  {
    'folke/todo-comments.nvim',
    name = 'todo-comments',
    dependencies = { 'plenary' },
    event = 'BufReadPost',
    opts = {
      highlight = { keyword = 'fg', after = '' },
      keywords = {
        FIX = {
          icon = static.icons.comments.bug .. ' ',
          color = 'error',
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'CHECK', 'PERF!' },
        },
        TODO = { icon = static.icons.comments.todo .. ' ', color = 'info', alt = { 'TODO!' } },
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
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = true,
  },
  -- TODO: Is this needed if with `snacks.nvim`? <07-11-24>
  -- FIX: I want to use `zm` and `zr`, `zR` and `zM` as in original nvim. Should override nvim-ufo commands and have it
  -- work as indented. <20-03-25>
  {
    'kevinhwang91/nvim-ufo',
    name = 'ufo',
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
              { text = { builtin.foldfunc },      click = 'v:lua.ScFa' },
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
    event = 'BufReadPost',
    opts = {
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
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)

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
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
    },
  },
  {
    'edluffy/specs.nvim',
    name = 'specs',
    enabled = false, -- TODO: When fixed for nightly can be enabled again <26-03-24>
    event = 'UIEnter',
    config = true,
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

  -- TODO: Configure colours <05-10-23>
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    -- TODO: A probable typing error in the commit d343409a. Should report. <05-11-24>
    commit = 'e7a4442e055ec953311e77791546238d1eaae507',
    name = 'indent-blankline',
    event = 'BufReadPost',
    main = 'ibl',
    -- enabled = false,
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        char = '┃',
        -- show_first_indent_level = false,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'tex', -- FIX: LaTeX makes indent-blankline very slow, which considerably lowers the speed of insertmode input <18-01-24>
          'help',
          'markdown',
          'packer',
          'lspinfo',
          'checkhealth',
          'txt',
          'alpha',
          'lazy',
          'mason',
          'DiffviewFiles',
          'oil_preview',
          'dashboard',
        },
        buftypes = {
          'terminal',
        },
      },
      -- space_char = '·',
    },
  },
  { 'Bekaboo/deadcolumn.nvim', event = 'VeryLazy', enabled = false },
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
  {
    'mawkler/modicator.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
      local set = vim.api.nvim_set_hl
      local get = vim.api.nvim_get_hl
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
  {
    'Isrothy/neominimap.nvim',
    enabled = false,
    lazy = false, -- NOTE: It lazy-loads itself <17-08-24>
    keys = {
      { '<leader>m', '<cmd>Neominimap bufToggle<cr>', desc = 'Toggle minimap for current buffer' },
    },
    init = function()
      -- vim.opt.wrap = false -- Recommended
      -- vim.opt.sidescrolloff = 36 -- It's recommended to set a large value
      vim.g.neominimap = {
        auto_enable = true,
        win_filter = function(bufnr)
          return vim.g.neominimap_is_in_search
        end,
        exclude_buftypes = {
          'nofile',
          'nowrite',
          'quickfix',
          'terminal',
          'prompt',
        },
        buf_filter = function()
          return true
        end,
        -- TODO: Highlight for cursor position should be different than the search to distinguish them <17-08-24>
        search = {
          enabled = true,
          mode = 'line',
        },
      }
      vim.on_key(function(char)
        if vim.fn.mode() == 'n' then
          local is_search_nav_key = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
          if is_search_nav_key then
            vim.g.neominimap_is_in_search = true
            require('neominimap').winRefresh({}, {})
          else
            vim.g.neominimap_is_in_search = false
            require('neominimap').winRefresh({}, {})
          end
        end
      end, vim.api.nvim_create_namespace 'auto_search_nav')
    end,
  },
  -- TODO: Setup should be called in ftplugin settings. Add for julia documentation comments  <03-06-24>
  {
    'folke/paint.nvim',
    module = 'paint',
  },
}
