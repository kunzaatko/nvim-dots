-- TODO: Add https://github.com/disrupted/blink-cmp-conventional-commits as a source <21-02-25>
return {
  'saghen/blink.cmp',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },
    { 'saghen/blink.compat', lazy = true, config = true },
    'f3fora/cmp-spell',
    'dmitmel/cmp-digraphs',
    { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim', name = 'plenary' } },
    { 'kdheepak/cmp-latex-symbols' },
  },
  lazy = false,
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    cmdline = {
      keymap = {
        preset = 'super-tab',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_and_accept()
              cmp.hide()
              return true
            else
              return false
            end
          end,
          'fallback',
        },
      },
    },

    snippets = {
      preset = 'luasnip',
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'git',
        'digraphs',
        'buffer',
        'spell',
        'markdown',
        'latex_symbols',
      },
      per_filetype = {
        'codecompanion',
      },

      min_keyword_length = 1,
      providers = {
        lsp = {
          -- async = true,
          score_offset = 2,
        },
        snippets = {
          score_offset = 3,
        },
        path = {
          score_offset = 4,
        },
        digraphs = {
          name = 'digraphs',
          score_offset = 1,
          module = 'blink.compat.source',
          opts = {
            cache_digraphs_on_start = true,
          },
        },

        buffer = {
          score_offset = -2,
        },
        git = {
          name = 'git',
          module = 'blink.compat.source',
          opts = {
            filetypes = { 'gitcommit', 'NeogitCommitMessage', 'octo', 'gitrebase' },
            remotes = { 'upstream', 'origin', 'github' },
          },
        },
        latex_symbols = {
          name = 'latex_symbols',
          module = 'blink.compat.source',
        },
        spell = {
          name = 'spell',
          score_offset = -2,
          module = 'blink.compat.source',
        },
        markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink' },
      },
    },

    signature = { enabled = true }, -- NOTE: experimental <13-12-24>

    completion = {
      documentation = {
        auto_show = true,
      },
      trigger = {
        prefetch_on_insert = true,
      },
      menu = {
        --- @module 'blink.cmp'
        --- @type blink.cmp.Draw
        draw = {
          -- treesitter = true,
          padding = { 0, 1 },
          columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind', 'source_name', gap = 1 } },
        },
      },
      accept = {
        auto_brackets = {
          override_brackets_for_filetypes = {
            tex = { '{', '}' },
          },
        },
      },
    },

    fuzzy = {
      prebuilt_binaries = {
        download = false, -- NOTE: We are compiling them ourselves <13-12-24>
      },
    },

    -- opts_extend = { 'sources.default' },
  },
  config = function(_, opts)
    opts.completion.menu.draw.components = {
      kind_icon = {
        text = function(ctx)
          return ' ' .. ctx.kind_icon .. ctx.icon_gap .. ' '
        end,
      },
      kind = {
        text = function(ctx)
          return '(' .. ctx.kind .. ')'
        end,
      },
      source_name = {
        text = function(ctx)
          return '[' .. (static.icons.cmp[ctx.source_name] or ctx.source_name) .. ']'
        end,
      },
    }
    require('blink.cmp').setup(opts)
  end,
}
